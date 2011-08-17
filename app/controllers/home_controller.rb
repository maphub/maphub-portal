class HomeController < ApplicationController

  def index
    @recent_maps = Map.order("edit_date").limit(18).reverse()
  end
  
  def search
    
    @results = Hash.new
    @q = params[:q]
    
    unless params[:q].nil?
      @results[:maps] = Map.search do
        keywords params[:q]
      end.results
      
      @results[:annotations] = Annotation.search do
        keywords params[:q]
      end.results
    end
    
    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @results }
    end
    
  end

end
