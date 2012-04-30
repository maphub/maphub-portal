class ControlPoint < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  # The Geonames RDF URI for this place
  def geonames_uri
    "http://sws.geonames.org/#{self.geonames_id}/"
  end
  
  def fragment_uri
    self.map.raw_image_uri + "#xywh=#{self.x.to_i},#{self.y.to_i},1,1"
  end
  
  
  
  # Writes annotation metadata in a given RDF serialization format
  def to_rdf(format, options = {})
    
    httpURI = options[:httpURI] ||= "http://example.com/missingBaseURI"
    
    # Defining the custom vocabulary # TODO: move this to separate lib
    oa_uri = RDF::URI('http://www.w3.org/ns/openannotation/core/')
    oa = RDF::Vocabulary.new(oa_uri)
    oax_uri = RDF::URI('http://www.w3.org/ns/openannotation/extensions/')
    oax = RDF::Vocabulary.new(oax_uri)
    maphub_uri = RDF::URI('http://maphub.info/ns/vocab#')
    maphub = RDF::Vocabulary.new(maphub_uri)
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
    graph << [baseURI, oa.hasMotivation, oax.Tagging]
    graph << [baseURI, RDF.type, maphub.GeoReference]
    graph << [baseURI, oa.generator, RDF::URI("http://www.maphub.info")]
    
    # Adding user and provenance data
    user_uuid = UUIDTools::UUID.timestamp_create().to_s
    user_node = RDF::URI.new(user_uuid)
    graph << [baseURI, oa.annotator, user_node]
    graph << [user_node, foaf.mbox, RDF::Literal.new(self.user.email)]
    graph << [user_node, foaf.name, RDF::Literal.new(self.user.username)]

    
    # Adding the body
    graph << [baseURI, oax.hasSemanticTag, RDF::URI(self.geonames_uri)]
    
    # Adding the target
    graph << [baseURI, oa.hasTarget, RDF::URI(self.fragment_uri)]
    graph << [RDF::URI(self.fragment_uri), oa.hasSource, self.map.raw_image_uri]
    
    # Serializing RDF graph to string
    RDF::Writer.for(format.to_sym).buffer do |writer|
      writer.prefix :dcterms, RDF::URI('http://purl.org/dc/terms/')
      writer.prefix :oa, oa_uri
      writer.prefix :oax, oax_uri
      writer.prefix :rdf, RDF::URI(RDF.to_uri)
      writer.prefix :maphub, maphub_uri
      writer.prefix :foaf, foaf_uri
      writer << graph
    end
    
  end

  
end
