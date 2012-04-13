class MapsController < ApplicationController
  
  # forward to root; think about browsing view
  def index
    redirect_to :root
  end
  
  
  # Render a single map
  def show
    @map = Map.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json {render :json => @map}
      format.xml {render :xml => @map}
      format.rdfxml {render :inline => @map.to_rdfxml}
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
