class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "default" # <= Use twitter-bootstrap layout called "default" per default



  #
  # Optional mobile views based on:
  # http://erniemiller.org/2011/01/05/mobile-devices-and-rails-maintaining-your-sanity/
  #  
  before_filter :prepend_mobile_path
  def prepend_mobile_path() if mobile_request? then prepend_view_path Rails.root+'app'+'mobile_views' end end
  def mobile_request?() request.subdomains.first == 'm' end
  helper_method :mobile_request?


  
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
