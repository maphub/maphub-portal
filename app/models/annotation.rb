class Annotation < ActiveRecord::Base

  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  has_many :tags
  
  validates_presence_of :body, :map

  def truncated_body
    if body.length > 30
      truncated_body = body[0, 30] + "..."
    else
      truncated_body = body
    end
    truncated_body
  end
  
  def segment
    # TODO: parse only once after creation
    Segment.create_from_wkt_data(self.wkt_data)
  end
  
  # Finds tags for given input text
  def self.find_tags(text)
    # TODO implement lookup
    text.to_json
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
      selector_uuid = UUIDTools::UUID.timestamp_create().to_s
      selector_node = RDF::URI.new(selector_uuid)
      graph << [specific_target, oa.hasSelector, selector_node]
      graph << [selector_node, RDF.type, ct.ContentAsText]
      graph << [selector_node, RDF::DC.format, "image/svg"]
      graph << [selector_node, ct.chars, self.segment.to_svg(self.map.width, 
        self.map.height)]

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
    %{
    <?xml version="1.0" standalone="no"?>
    <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
      "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
      <svg width="#{width}px" height="#{height}px"
         xmlns="http://www.w3.org/2000/svg" version="1.1">
         #{svg_shape}
      </svg>
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
    %{<polyline 
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
    %{<polygon 
              points="#{to_s}" />
    }
  end
  
end




