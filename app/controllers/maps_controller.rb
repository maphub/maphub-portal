class MapsController < ApplicationController
  
  # Show all maps
  def index
    @maps = Map.all

    respond_to do |format|
      format.html # index.html.erb
      format.json # index.json.erb
#		format.json { render :file => 'index.json.erb', :content_type => 'application/json' }
    end
  end
  
  # Render a single map
  def show
    @map = Map.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json # show.json.erb
      format.xml  {render :xml => @map}
      format.rdf  {render :rdf => @map, :httpURI => base_uri(request.url)}
      format.ttl  {render :ttl => @map, :httpURI => base_uri(request.url)}
      format.nt  {render :nt => @map, :httpURI => base_uri(request.url)}
    end
    
  end
  
end
