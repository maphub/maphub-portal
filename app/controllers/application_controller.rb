class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "default" # <= Use twitter-bootstrap layout called "default" per default
  
  
  # Cuts a possible filename from the given URI
  # => http://localhost:3000/maps/1.rdf => http://localhost:3000/maps/1
  def base_uri(uri)
    ext = File.extname(uri)
    unless ext.length == 0
      uri = uri[0..(ext.length + 1)*-1]
    end
    uri
  end
  
end
