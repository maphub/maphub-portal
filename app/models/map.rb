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
  validate :has_proper_tileset
  
  def thumbnail_uri
    "#{tileset_uri}/TileGroup0/0-0-0.jpg"
  end
  
  # Checks if the "ImageProperties.xml" file exists at the
  # given Tileset URL
  def has_proper_tileset
    tileset_url.chomp!('/') # remove trailing slash just in case
    url = URI.parse "#{tileset_url}/ImageProperties.xml"
    Net::HTTP.start(url.host, url.port) do |http|
      unless http.head(url.request_uri).code == "200"
        errors.add(:tileset_url, " does not appear to be valid. Are you sure there is an ImageProperties.xml file?")
      end
    end
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
    
  def to_ttl
    rdf(:ttl)
  end
  
  def rdf(format)
    graph = RDF::Graph.new << [:hello, RDF::DC.title, "Hello, world!"]
    graph.dump(format)
  end
  

end
