class MapsController < ApplicationController
  
  # Render a single map
  def show
    @map = Map.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json {render :json => @map}
    end
  end

  # def annotate
  #   # read the the posted annotation and save with the map
  # end
  # 
  # def georeference
  #   # read the posted controlpoint and save with the map
  # end
end
