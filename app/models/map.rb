require 'open-uri'
require 'net/http'

# This class represents data about a historic map.
#
# Maps don't belong to any user. A map can have annotations and control points.

class Map < ActiveRecord::Base
  
  #has_many :annotations
  #has_many :controlpoints
  
  before_validation :extract_dimensions
  
  validates_presence_of :title, :tileset_uri, :width, :height
  
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
  
  def to_rdfxml
    graph = RDF::Graph.new << [:hello, RDF::DC.title, "Hello, world!"]
    graph.dump(:rdfxml)
  end
  

end
