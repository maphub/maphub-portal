require 'open-uri'
require 'net/http'

# This class represents data about a historic map.
#
# Maps don't belong to any user. A map can have annotations and control points.

class Map < ActiveRecord::Base
  
  has_many :annotations
  #has_many :controlpoints
  
  before_validation :extract_dimensions
  validates_presence_of :title, :tileset_uri, :width, :height
  
  def thumbnail_uri
    "#{tileset_uri}/TileGroup0/0-0-0.jpg"
  end
  
  # Extracts image dimensions from ImageProperties.xml;
  def extract_dimensions
    tileset_uri.chomp!('/') # remove trailing slash just in case
    url = URI.parse "#{tileset_uri}/ImageProperties.xml"
    response = Net::HTTP.get_response(url)
    if response.code == "200"
      self.width = response.body.match(/width="(\d*)"/i).captures.first
      self.height = response.body.match(/height="(\d*)"/i).captures.first
    end
    
  end
    
  # Writes map metadata in a given RDF serialization format
  def to_rdf(format, options = {})
    
    httpURI = options[:httpURI] ||= "http://example.com/missingBaseURI"
    
    # building the graph
    baseURI = RDF::URI.new(httpURI)
    graph = RDF::Graph.new
    graph << [baseURI, RDF::DC.title, self.title] unless self.title.nil?
    graph << [baseURI, RDF::DC.subject, self.subject] unless self.subject.nil?
    
    # Serializing RDF graph to string
    RDF::Writer.for(format.to_sym).buffer do |writer| 
      writer.prefix :dcterms, RDF::URI('http://purl.org/dc/terms/')
      writer << graph
    end
    
  end
  

end
