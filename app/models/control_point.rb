class ControlPoint < ActiveRecord::Base
  
  GEONAMES_API_BASEURL = "http://api.geonames.org/searchJSON"
  GEONAMES_BASEURL = "http://sws.geonames.org/"
  GEONAMES_USER = "maphub"
  MAX_ROWS = 10
  
  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  # A human-readable label consisting of place name and country code
  def label
    "#{name} (#{countryCode})"
  end
  
  
  # Searches Geonames for a given place and returns an array
  # of controlpoint objects filled with name, uri, lat, and long
  def self.find_in_geonames(place)
    
    control_points = []
    
    puts "Called find_in_geonames with paramter #{place}"

    url = "#{GEONAMES_API_BASEURL}?name=#{URI.encode(place)}&maxRows=#{MAX_ROWS}&username=#{GEONAMES_USER}"
    
    puts "Executing request: #{url}"
    
    resp = Net::HTTP.get_response(URI.parse(url))
    puts resp
    
    case resp
    when Net::HTTPSuccess
        data = resp.body
        result = JSON.parse(data)
        places = result["geonames"]
        places.each do |place|
          name = place["name"]
          countryCode = place["countryCode"]
          lat = place["lat"]
          lng = place["lng"]
          geonamesID = place["geonameId"]
          
          control_point = ControlPoint.new
          control_point.name = name
          control_point.countryCode = countryCode
          control_point.lat = lat
          control_point.lng = lng
          control_point.geonames_uri = "#{GEONAMES_BASEURL}#{geonamesID}/"
          
          control_points << control_point
        end
    else
      #resp.error!
    end
    
    control_points
  end
  
end