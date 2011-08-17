class HomeController < ApplicationController

  def index
    @recent_maps = Map.order("edit_date").limit(18).reverse()
  end
  
  def search
    unless params[:q].nil?
      @search = Map.search do
        keywords(params[:q])
      end
    end
    
    
    
  end

end
