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

  # PUT /maps/1
  # PUT /maps/1.xml
  def update
    @map = Map.find(params[:id])
    boundary = @map.boundary
    boundary.update_attributes({
    	'ne_lat' => params['ne_lat'],
    	'ne_lng' => params['ne_lng'],
    	'sw_lat' => params['sw_lat'],
    	'sw_lng' => params['sw_lng']
    })
    boundary.save
    redirect_to :action => 'index'
  end
end
