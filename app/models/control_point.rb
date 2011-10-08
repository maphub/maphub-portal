require 'net/http'

class ControlPoint < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  # Uses the GeoNames service to search for control points
  def self.find_in_geonames(place)
    geoNames_client = GeoNamesClient.new
    geoNames_client.find_control_points(place)
  end
  
end