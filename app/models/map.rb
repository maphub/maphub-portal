require 'open-uri'
require 'net/http'

# This class represents data about a historic map.
#
# Maps don't belong to any user. A map can have annotations and control points.

class Map < ActiveRecord::Base
  
  # Hooks  
  before_validation :extract_dimensions
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
      tag_labels << annotation.tags.collect(&:label).join(" ")
    end
    tag_labels.join(" ")
  end
  
  # Collects all enrichment labels into a single string
  def annotations_enrichments
    tag_enrichments = []
    annotations.each do |annotation|
      tag_enrichments << annotation.tags.collect(&:enrichment).join(" ")
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
  
  # TODO: this should be in a central APP configuration file
  def map_base_uri
    "http://samos.mminf.univie.ac.at/maps"
  end
  
  def raw_image_uri
    "#{map_base_uri}/raw/#{self.identifier}.jp2"    
  end
  
  def tileset_uri
    "#{map_base_uri}/ts_zoomify/#{self.identifier}"
  end
  
  def thumbnail_uri
    "#{map_base_uri}/thumbnails/#{self.identifier}.jpg"
  end
  
  def thumbnail_small_uri
    "#{self.tileset_uri}/TileGroup0/0-0-0.jpg"
  end
  
  # the URI of the Google Maps overlay tileset
  def overlay_tileset_uri
    begin
      uri = "#{map_base_uri}/ts_google/#{self.identifier}/"
      response_code = Net::HTTP.get_response(URI.parse(uri)).code
      (response_code == "200") ? uri : nil
    rescue
      nil
    end
  end
  
  # a truncated title
  def short_title
    (title.length > 30) ? title[0, 30] + "..." : title
  end
  
  # the number of control points
  def no_control_points
    self.control_points.count
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
    
end
