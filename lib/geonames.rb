require 'net/http'

class GeoNamesClient
  
  GEONAMES_API_BASEURL = "http://api.geonames.org/searchJSON"
  GEONAMES_BASEURL = "http://sws.geonames.org/"
  GEONAMES_USER = "maphub"
  MAX_ROWS = 10
  
  def initialize
    
  end
  
  # Finds control points in Geonames for a given placename
  def find_control_points(place)
    
    puts "Method called"
    
    control_points = []
    
    url = "#{GEONAMES_API_BASEURL}?name=#{URI.encode(place)}&maxRows=#{MAX_ROWS}&username=#{GEONAMES_USER}"
    
    resp = Net::HTTP.get_response(URI.parse(url))
    
    puts resp
        
    case resp
    when Net::HTTPSuccess
        puts "success"
        data = resp.body
        result = JSON.parse(data)
        places = result["geonames"]
        places.each do |place|
          # Create a new control point for each geonames result
          control_point = ControlPoint.new
          control_point.name = place["toponymName"]
          control_point.label = "#{place["name"]} (#{place["countryCode"]})"
          control_point.lat = place["lat"]
          control_point.lng = place["lng"]
          control_point.geonames_uri = "#{GEONAMES_BASEURL}#{place["geonameId"]}/"
          
          control_points << control_point
        end
    else
      resp.error!
    end
    
    control_points
  end
  
end