class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "default" # <= Use twitter-bootstrap layout called "default" per default
  
  
  # Cuts a possible filename from the given URI
  # => http://localhost:3000/maps/1.rdf => http://localhost:3000/maps/1
  def get_base_uri
    ext = File.extname(request.url)
    unless ext.length == 0
      @base_uri = request.url[0..(ext.length + 1)*-1]
    end
  end
  
  # Returns the URI scheme name and authority
  # => http://localhost:3000/maps/1.rdf => http://localhost:3000
  def get_host
    request_url = Addressable::URI.parse(request.url)
    @host = request_url.scheme + "://" + request_url.host + ":" + request_url.port.to_s
  end
  
end
