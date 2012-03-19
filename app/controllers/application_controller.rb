class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "default" # <= Use twitter-bootstrap layout called "default" per default
end
