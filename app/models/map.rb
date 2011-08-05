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
  
end
