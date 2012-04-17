class Annotation < ActiveRecord::Base

  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  validates_presence_of :body, :map

  def truncated_body
    if body.length > 30
      truncated_body = body[0, 30] + "..."
    else
      truncated_body = body
    end
    truncated_body
  end
  
  
  # Writes annotation metadata in a given RDF serialization format
  def to_rdf(format, options = {})
    
    httpURI = options[:httpURI] ||= "http://example.com/missingBaseURI"
    
    # Defining the custom vocabulary # TODO: move this to separate lib
    oa_uri = RDF::URI('http://www.w3.org/ns/openannotation/core#')
    oa = RDF::Vocabulary.new(oa_uri)
    ct_uri = RDF::URI('http://www.w3.org/2011/content#')
    ct = RDF::Vocabulary.new(ct_uri)
    
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
    
    # Creating the body
    unless self.body.nil?
      body_uuid = UUIDTools::UUID.timestamp_create().to_s
      body_node = RDF::URI.new(body_uuid)
      graph << [baseURI, oa.hasBody, body_node]
      graph << [body_node, RDF.type, ct.ContentAsText]
      graph << [body_node, ct.chars, self.body]
      graph << [body_node, RDF::DC.format, "text/plain"]
    end
    
    # Creating the target; TODO: fragment information is still missing
    unless self.map.nil?
      target_uuid = UUIDTools::UUID.timestamp_create().to_s
      target_node = RDF::URI.new(target_uuid)
      graph << [baseURI, oa.hasTarget, self.map.tileset_uri]
    end
    
    # Serializing RDF graph to string
    RDF::Writer.for(format.to_sym).buffer do |writer|
      writer.prefix :dcterms, RDF::URI('http://purl.org/dc/terms/')
      writer.prefix :oa, oa_uri
      writer.prefix :ct, ct_uri
      writer.prefix :rdf, RDF::URI(RDF.to_uri)
      writer << graph
    end
    
  end

end