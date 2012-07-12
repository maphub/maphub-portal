require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'ostruct'

# This class represents data about a historic map.
#
# Maps don't belong to any user. A map can have annotations and control points.

class Map < ActiveRecord::Base
  
  # Hooks  
  before_validation :has_tileset?, :extract_dimensions
  after_create :create_boundary_object
  
  # Validation
  validates_presence_of :identifier, :title, :width, :height
  
  # Model associations
  has_many :annotations
  has_many :control_points
  has_one :boundary, :as => :boundary_object
  accepts_nested_attributes_for :boundary
  
  # Search
  searchable do 
    text :title, :boost => 2.0
    text :subject
    string :author
    text :annotations_content, :boost => 1.0
    text :annotations_tags, :boost => 1.0
    text :annotations_enrichments, :boost => 1.0
  end
  
  # Collects all annotations into a single string
  def annotations_content
    annotations.collect(&:body).join(" ")
  end
  
  # Collects all tag labels into a single string
  def annotations_tags
    tag_labels = []
    annotations.each do |annotation|
    	annotation.tags.each do |tag|
    		if tag.accepted?
      		tag_labels << tag.label
      	end
      end
    end
    tag_labels.join(" ")
  end
  
  # Collects all enrichment labels into a single string
  def annotations_enrichments
    tag_enrichments = []
    annotations.each do |annotation|
    	annotation.tags.each do |tag|
    		if tag.accepted?
      		tag_enrichments << tag.enrichment
      	end
      end
    end
    tag_enrichments.join(" ")
  end
  
  # Creates an empty boundary object for the map after creation
  def create_boundary_object
    boundary = self.build_boundary
    boundary.ne_x = self.width
    boundary.ne_y = self.height
    boundary.sw_x = 0
    boundary.sw_y = 0
    boundary.save
  end
  
  # virtual attributes
  def map_base_uri
    Rails.configuration.map_base_uri
  end
  
  def raw_image_uri
    "#{map_base_uri}/raw/#{identifier}.jp2"    
  end
  
  def tileset_uri
    "#{map_base_uri}/ts_zoomify/#{identifier}"
  end
  
  def thumbnail_uri
    "#{map_base_uri}/thumbnails/#{identifier}.jpg"
  end
  
  def thumbnail_small_uri
    "#{tileset_uri}/TileGroup0/0-0-0.jpg"
  end
  
  def image_properties_uri
    "#{tileset_uri}/ImageProperties.xml"
  end
  
  def overlay_tileset_uri
    "#{map_base_uri}/ts_google/#{identifier}"
  end
  
  def overlay_properties_uri
    "#{overlay_tileset_uri}/tilemapresource.xml"
  end
  
  # a truncated title
  def short_title
    (title.length > 30) ? title[0, 30] + "..." : title
  end
  
  # the number of control points
  def no_control_points
    self.control_points.count
  end
  
  # checks whether the overlay tileset exists
  def has_overlay?
    if self.overlay_available.nil?
      url = URI.parse overlay_properties_uri
      begin
        response = Net::HTTP.get_response(url)
        self.overlay_available = (response.code == "200")
        self.save
        return self.overlay_available
      rescue
        false
      end
    else
      return self.overlay_available
    end
  end
  
  # checks whether the remote tileset exists
  def has_tileset?
    url = URI.parse image_properties_uri
    begin
      response = Net::HTTP.get_response(url)
      return response.code == "200"
    rescue
      false
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
  
  # Exctracs boundary information from overlay tileset 
  def overlay_boundary
    begin
      doc = Nokogiri::XML(open(overlay_properties_uri))
    rescue
      self.overlay_available = false
      return nil
    end
    unless doc.nil?
      bounding_box = doc.xpath("//BoundingBox[@minx]")
      min_tileset = doc.xpath("//TileSets/TileSet[1]")
      max_tileset = doc.xpath("//TileSets/TileSet[last()]")

      ret = OpenStruct.new 
      ret.ne_lat = bounding_box.attribute("maxx").content
      ret.ne_lng = bounding_box.attribute("maxy").content
      ret.sw_lat = bounding_box.attribute("minx").content
      ret.sw_lng = bounding_box.attribute("miny").content
      ret.min_tileset = min_tileset.attribute("order").content
      ret.max_tileset = max_tileset.attribute("order").content
      return ret
    end
  end
  
end
