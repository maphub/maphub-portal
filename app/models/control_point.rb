class ControlPoint < ActiveRecord::Base
  
  # Validation
  validates_presence_of :geonames_id, :lat, :lng, :x, :y
  
  # Hooks
  after_create :update_map, :recalc_boundaries
  
  # Model associations
  belongs_to :user, :counter_cache => true
  belongs_to :map
    
  def update_map
    map.update_attribute(:updated_at, Time.now)
  end
  
  # recalculates the edges of the map boundary into real-world coordinates
  def recalc_boundaries
    if map.control_points.count > 2
      map.boundary.recalc
      for annotation in map.annotations
        annotation.boundary.recalc
      end
    end
  end
  
  # The Geonames RDF URI for this place
  def geonames_uri
    "http://sws.geonames.org/#{self.geonames_id}/"
  end
  
  def fragment
    "xywh=#{self.x.to_i},#{self.y.to_i},1,1"
  end
  
  
  # LAT/LON and X/Y are assumed to be related via an affine transform.
  # An affine transform takes the form
  # 
  #   x = a * u + b * v + c
  #   y = d * u + e * v + f
  # 
  # where x and y are the point's unknown X/Y coordinates (image space);
  # and u and v are the point's known geographical coordinates (u = lat,
  # v = lon). Coefficients a, b, c, d, e, f can be computed if three
  # control points are known (in image space and geo-coordinate space).
  # 
  # The known coordinates of the three control points are denoted as
  # 
  # CP1: x1/y1 (image space) u1/v1 (lat/lon)
  # CP2: x2/y2               u2/v2
  # CP3: x3/y3               u3/v3 
  def self.compute_xy_from_known_latlng(lat, lng, control_points)
    raise ArgumentError if control_points.length != 3
    
    # Compute matrix coefficients
    x1 = control_points[0].x;
    y1 = control_points[0].y;
    x2 = control_points[1].x;
    y2 = control_points[1].y;
    x3 = control_points[2].x;
    y3 = control_points[2].y;

    u1 = control_points[0].lat;
    v1 = control_points[0].lng;
    u2 = control_points[1].lat;
    v2 = control_points[1].lng;
    u3 = control_points[2].lat;
    v3 = control_points[2].lng;

    a = (x2 * (v3 - v1) - x3 * (v2 - v1) - x1 * (v3 - v2))/
        ((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
    b = (x2 * (u3 - u1) - x3 * (u2 - u1) - x1 * (u3 - u2))/
        ((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
    c = x1 - a * u1 - b * v1;

    d = (y2 * (v3 - v1) - y3 * (v2 - v1) - y1 * (v3 - v2))/
        ((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
    e = (y2 * (u3 - u1) - y3 * (u2 - u1) - y1 * (u3 - u2))/
        ((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
    f = y1 - d * u1 - e * v1;

    # Compute transform
    x = a * lat + b * lng + c;
    y = d * lat + e * lng + f;

    return x, y
  end
  
  
  def self.compute_latlng_from_known_xy(x, y, control_points)
      raise ArgumentError if control_points.length != 3

      # Compute matrix coefficients
      x1 = control_points[0].x;
      y1 = control_points[0].y;
      x2 = control_points[1].x;
      y2 = control_points[1].y;
      x3 = control_points[2].x;
      y3 = control_points[2].y;

      u1 = control_points[0].lat; 
      v1 = control_points[0].lng;
      u2 = control_points[1].lat;
      v2 = control_points[1].lng;
      u3 = control_points[2].lat;
      v3 = control_points[2].lng;

      a = (u2 * (y3 - y1) - u3 * (y2 - y1) - u1 * (y3 - y2))/
          ((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1));    
      b = (u2 * (x3 - x1) - u3 * (x2 - x1) - u1 * (x3 - x2))/
          ((y2 - y1) * (x3 - x1) - (y3 - y1) * (x2 - x1));
      c = u1 - a * x1 - b * y1;

      d = (v2 * (y3 - y1) - v3 * (y2 - y1) - v1 * (y3 - y2))/
          ((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1));
      e = (v2 * (x3 - x1) - v3 * (x2 - x1) - v1 * (x3 - x2))/
          ((y2 - y1) * (x3 - x1) - (y3 - y1) * (x2 - x1));      
      f = v1 - d * x1 - e * y1;

      # Compute transform
      u = a * x + b * y + c;
      v = d * x + e * y + f;

      return u,v
  end
  
  
  
  # Writes annotation metadata in a given RDF serialization format
  def to_rdf(format, options = {})
    
    # TODO: type of tagging
    
    httpURI = options[:httpURI] ||= "http://example.com/missingBaseURI"
    host = options[:host] ||= "http://maphub.info"
    
    # Defining the custom vocabulary # TODO: move this to separate lib
    oa_uri = RDF::URI('http://www.w3.org/ns/openannotation/core/')
    oa = RDF::Vocabulary.new(oa_uri)
    oax_uri = RDF::URI('http://www.w3.org/ns/openannotation/extensions/')
    oax = RDF::Vocabulary.new(oax_uri)
    maphub_uri = RDF::URI('http://maphub.info/ns/vocab#')
    maphub = RDF::Vocabulary.new(maphub_uri)
    foaf_uri = RDF::URI('http://xmlns.com/foaf/spec/')
    foaf = RDF::Vocabulary.new(foaf_uri)
    dcterms_uri = RDF::URI('http://purl.org/dc/dcmitype/')
    dcterms = RDF::Vocabulary.new(dcterms_uri)
    dc_uri = RDF::URI('http://purl.org/dc/elements/1.1/')
    dc = RDF::Vocabulary.new(dc_uri)
    
    # Building the annotation graph
    baseURI = RDF::URI.new(httpURI)
    graph = RDF::Graph.new
    graph << [baseURI, RDF.type, oa.Annotation]
    graph << [baseURI, RDF.type, oax.Tagging]
    graph << [baseURI, RDF.type, maphub.GeoReference]
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
    graph << [baseURI, oa.generator, RDF::URI(host)]
    
    # Adding user and provenance data
    user_uuid = UUIDTools::UUID.timestamp_create().to_s
    user_node = RDF::URI.new(user_uuid)
    graph << [baseURI, oa.annotator, user_node]
    graph << [user_node, foaf.mbox, RDF::Literal.new(self.user.email)]
    graph << [user_node, foaf.name, RDF::Literal.new(self.user.username)]

    
    # Adding the body
    unless self.geonames_uri.nil?
      graph << [baseURI, oax.hasSemanticTag, RDF::URI(self.geonames_uri)]      
    end

    # Adding the target
    specific_target_uuid = UUIDTools::UUID.timestamp_create().to_s
    specific_target = RDF::URI.new(specific_target_uuid)
    graph << [baseURI, oa.hasTarget, specific_target]
    graph << [specific_target, RDF.type, oa.SpecificResource]
    source_node = RDF::URI.new(self.map.raw_image_uri)
    graph << [specific_target, oa.hasSource, source_node]
    
    # Source details
    graph << [source_node, RDF.type, dcterms.StillImage]
    graph << [source_node, dc.format, "image/jp2"]
    
    # the Point selector
    point_selector_uuid = UUIDTools::UUID.timestamp_create().to_s
    point_selector_node = RDF::URI.new(point_selector_uuid)
    graph << [specific_target, oa.hasSelector, point_selector_node]
    graph << [point_selector_node, RDF.type, oa.FragmentSelector]
    graph << [point_selector_node, RDF.value, self.fragment]
    
    # Serializing RDF graph to string
    RDF::Writer.for(format.to_sym).buffer do |writer|
      writer.prefix :dcterms, RDF::URI('http://purl.org/dc/terms/')
      writer.prefix :oa, oa_uri
      writer.prefix :oax, oax_uri
      writer.prefix :rdf, RDF::URI(RDF.to_uri)
      writer.prefix :maphub, maphub_uri
      writer.prefix :foaf, foaf_uri
      writer.prefix :dcterms, dcterms_uri
      writer.prefix :dc, dc_uri
      writer << graph
    end
    
  end
  
end
