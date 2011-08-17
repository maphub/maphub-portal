require 'open-uri'
require 'net/http'

class Map < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  has_many :annotations
  has_and_belongs_to_many :collections
  
  # Validate for a title and a tileset given
  validates_presence_of :title, :tileset_url
  
  # Validate for a proper tileset
  validate :has_proper_tileset
  
  # After validation: Check width and height
  after_validation :parse_dimensions
  
  searchable do
    text :title, :default_boost => 2
    text :description
  end
  
  def thumbnail_url
    "#{tileset_url}/TileGroup0/0-0-0.jpg"
  end
  
  private
  
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
  
  # Parses pixel width and height from the "ImageProperties.xml" file
  # This will be used for the correct display within OpenLayers
  def parse_dimensions
    tileset_url.chomp!('/') # remove trailing slash just in case
    url = URI.parse "#{tileset_url}/ImageProperties.xml"
    image_properties = Net::HTTP.get(url)
    self.width = image_properties.match(/width="(\d*)"/i).captures.first
    self.height = image_properties.match(/height="(\d*)"/i).captures.first
  end
  
end
