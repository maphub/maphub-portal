class HomeController < ApplicationController

  def index
    @recent_maps = Map.order("edit_date").limit(18).reverse()
  end

end
