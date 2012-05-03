class Admin::MapsController < ApplicationController

  # See: http://www.rubyfleebie.com/restful-admin-controllers-and-views-with-rails/

  # Return / render a list of all maps
  def index
    @maps = Map.all
    
    respond_to do |format|
      format.html # index.html
      format.json {render :json => @maps}
    end
    
  end

end
