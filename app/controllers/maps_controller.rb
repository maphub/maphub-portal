class MapsController < ApplicationController
  
  # Show all maps
  def index
    @maps = Map.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json {render :json => @maps.to_json(
                                    :only =>[:id,:updated_at],
                                    :methods => [:no_control_points]
                                                )}
    end
  end
  
  # Render a single map
  def show
    @map = Map.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json # show.json.erb
      format.rdf  # show.rdf.erb
    end
    
  end
  
end
