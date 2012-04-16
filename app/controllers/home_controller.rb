class HomeController < ApplicationController

  def index
    @recent_maps = Map.order("updated_at").limit(18).reverse()
  end
  
end