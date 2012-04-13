class MapsController < ApplicationController
  
<<<<<<< HEAD
  # forward to root; think about browsing view
  def index
    redirect_to :root
  end
  
  
=======
  # Show all maps
  def index
    @maps = Map.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json {render :json => @map}
    end
  end
  
>>>>>>> 2a4d4db9f13d8d31f7ec7bca690575e65810c09c
  # Render a single map
  def show
    @map = Map.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json {render :json => @map}
      format.xml {render :xml => @map}
      format.ttl { render :ttl => @map}
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
