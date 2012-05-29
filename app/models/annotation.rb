require 'open-uri'
require 'net/http'

class Annotation < ActiveRecord::Base

  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  has_one :boundary, :as => :boundary_object
  accepts_nested_attributes_for :boundary
  
  has_many :tags
  
  after_create :update_map
  
  validates_presence_of :body, :map

  def truncated_body
    (body.length > 30) ? body[0, 30] + "..." : body
  end
  
  def update_map
    map.update_attribute(:updated_at, Time.now)
  end
  
  def segment
    # TODO: parse only once after creation
    Segment.create_from_wkt_data(self.wkt_data)
  end
  
  # Finds tags for given input text
  def self.find_tags_from_text(text)
    # TODO implement real lookup
    tags = []
    5.times do
      r = rand(1000)
      tag = {
        dbpedia_uri: "dbpedia-uri-#{r}",
        label: "label-#{r}"
      }
      tags << tag
    end
    tags
  end
  
  # Finds matching nearby Wikipedia articles for the location
  def self.find_tags_from_boundary(map, boundary)
    tags = []
    # if there are more than two control points, we have the boundaries for this map
    if map.control_points.count > 2
      
      # get the edges of the boundary box
      north, east = ControlPoint.compute_latlng_from_known_xy(boundary.ne_y, boundary.ne_x, map.control_points.first(3))
      south, west = ControlPoint.compute_latlng_from_known_xy(boundary.sw_y, boundary.sw_x, map.control_points.first(3))
      
      logger.debug "Boundaries:     #{boundary.inspect}"
      logger.debug "New boundaries: #{south.to_f.round(2)} #{west.round(2)} #{east.round(2)} #{north.round(2)}"
      
      params = { north: north, west: west, east: east, south: south }

      # compose query
      query = "http://api.geonames.org/wikipediaBoundingBoxJSON?"
      params.each do |key, val|
        query << "#{key}=#{val.to_f}&"
      end
      
      # add username, we kinda need this, TODO: get our own?
      query << "maxRows=5&"
      query << "username=slhck"
      logger.debug "#{query.inspect}"
      
      # parse response
      url = URI.parse(query)
      response = Net::HTTP.get_response(url)
      if response.code == "200"
        response = ActiveSupport::JSON.decode response.body
        response["geonames"].each do |entry|
          tag = {
            label: entry["title"].gsub(" ", "-").downcase,
            dbpedia_uri: entry["wikipediaUrl"]
          }
          tags << tag
        end
      end
      
    end
    
    tags
  end
  
  # Writes annotation metadata in a given RDF serialization format
  def to_rdf(format, options = {})
    
    httpURI = options[:httpURI] ||= "http://example.com/missingBaseURI"
    
    # Defining the custom vocabulary # TODO: move this to separate lib
    oa_uri = RDF::URI('http://www.w3.org/ns/openannotation/core#')
    oa = RDF::Vocabulary.new(oa_uri)
    ct_uri = RDF::URI('http://www.w3.org/2011/content#')
    ct = RDF::Vocabulary.new(ct_uri)
    foaf_uri = RDF::URI('http://xmlns.com/foaf/spec/')
    foaf = RDF::Vocabulary.new(foaf_uri)    
    
    # Building the annotation graph
    baseURI = RDF::URI.new(httpURI)
    graph = RDF::Graph.new
    graph << [baseURI, RDF.type, oa.Annotation]
    unless self.created_at.nil?
      graph << [
        baseURI,
        oa.annotated, 
        RDF::Literal.new(self.created_at, :datatype => RDF::XSD::dateTime)]
    end
    unless self.updated_at.nil?
      graph << [
        baseURI,
        oa.generated, 
        RDF::Literal.new(self.updated_at, :datatype => RDF::XSD::dateTime)]
    end
    graph << [baseURI, oa.generator, RDF::URI("http://www.maphub.info")]
    
    # Adding user and provenance data
    user_uuid = UUIDTools::UUID.timestamp_create().to_s
    user_node = RDF::URI.new(user_uuid)
    graph << [baseURI, oa.annotator, user_node]
    graph << [user_node, foaf.mbox, RDF::Literal.new(self.user.email)]
    graph << [user_node, foaf.name, RDF::Literal.new(self.user.username)]
    
    # Creating the body
    unless self.body.nil?
      body_uuid = UUIDTools::UUID.timestamp_create().to_s
      body_node = RDF::URI.new(body_uuid)
      graph << [baseURI, oa.hasBody, body_node]
      graph << [body_node, RDF.type, ct.ContentAsText]
      graph << [body_node, ct.chars, self.body]
      graph << [body_node, RDF::DC.format, "text/plain"]
    end
    
    # Creating the target
    unless self.map.nil?
      # the specific target
      specific_target_uuid = UUIDTools::UUID.timestamp_create().to_s
      specific_target = RDF::URI.new(specific_target_uuid)
      graph << [baseURI, oa.hasTarget, specific_target]
      graph << [specific_target, RDF.type, oa.SpecificResource]
      
      # the SVG selector
      svg_selector_uuid = UUIDTools::UUID.timestamp_create().to_s
      svg_selector_node = RDF::URI.new(svg_selector_uuid)
      graph << [specific_target, oa.hasSelector, svg_selector_node]
      graph << [svg_selector_node, RDF.type, ct.ContentAsText]
      graph << [svg_selector_node, RDF::DC.format, "image/svg"]
      graph << [svg_selector_node,
                  ct.chars,
                  self.segment.to_svg(self.map.width, self.map.height)]
      
      # the WKT selector
      wkt_selector_uuid = UUIDTools::UUID.timestamp_create().to_s
      wkt_selector_node = RDF::URI.new(wkt_selector_uuid)
      graph << [specific_target, oa.hasSelector, wkt_selector_node]
      graph << [wkt_selector_node, RDF.type, ct.ContentAsText]
      graph << [wkt_selector_node, RDF::DC.format, "application/wkt"]
      graph << [wkt_selector_node, ct.chars, self.wkt_data]

      # the target source
      graph << [specific_target, oa.hasSource, self.map.raw_image_uri]
    end
    
    # Serializing RDF graph to string
    RDF::Writer.for(format.to_sym).buffer do |writer|
      writer.prefix :dcterms, RDF::URI('http://purl.org/dc/terms/')
      writer.prefix :oa, oa_uri
      writer.prefix :ct, ct_uri
      writer.prefix :rdf, RDF::URI(RDF.to_uri)
      writer.prefix :foaf, foaf_uri
      writer << graph
    end
    
  end

end


# TODO: this should defenitely go to a separate class
class Segment
  
  def self.create_from_wkt_data(wkt_data)
    if wkt_data.start_with?("POLYGON")
      return Polygon.create_from_wkt_data(wkt_data)
    elsif wkt_data.start_with?("LINESTRING")
      return Linestring.create_from_wkt_data(wkt_data)
    elsif wkt_data.start_with?("POINT")
      return Point.create_from_wkt_data
    else
      raise "Unnown Segment shape: #{wkt_data}"
    end
    
  end
  
  def to_svg(width, height)
    # TODO: add namespace
    %{
    <?xml version="1.0" standalone="no"?>
         #{svg_shape}
    }
  end

end


class Point < Segment
  
  attr_reader :x, :y
  
  def initialize(x,y)
    @x = x
    @y = y
  end
  
  def self.create_from_wkt_data(wkt_data)
    data = wkt_data["POINT".length+1..-2]
    xy = data.split(" ")
    Point.new(xy[0], xy[1])
  end
  
  def to_s
    "#{@x},#{@y}"
  end
    
end

class Linestring < Segment

  attr_reader :points
  
  def initialize(points)
    @points = points
  end
  
  def self.create_from_wkt_data(wkt_data)
    points = []
    data = wkt_data["LINESTRING".length+1..-2]
    data.split(",").each do |point_pair|
      point = Point.create_from_wkt_data("POINT(#{point_pair})")
      points << point
    end
    Linestring.new(points)
  end
  
  def to_s
    @points.join(" ")
  end
    
  def svg_shape
    %{<polyline xmlns="http://www.w3.org/2000/svg"
              points="#{to_s}" />
    }
  end


end


class Polygon < Linestring
  
  def self.create_from_wkt_data(wkt_data)
    points = []
    data = wkt_data["POLYGON".length+2..-3]
    data.split(",").each do |point_pair|
      point = Point.create_from_wkt_data("POINT(#{point_pair})")
      points << point
    end
    Polygon.new(points)
  end

  def svg_shape
    %{<polygon xmlns="http://www.w3.org/2000/svg"
              points="#{to_s}" />
    }
  end
  
end




