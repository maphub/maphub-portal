class HomeController < ApplicationController

  def search
    
    @results = []
    @q = params[:q]
    
    unless params[:q].nil?
      maps = Map.search do
        keywords params[:q]
      end.results
      
      annotations = Annotation.search do
        keywords params[:q]
     end.results
      
      tags = Tag.search do
      	keywords params[:q]
      end.results
      
      # get the maps from the annotations and put them into one array
     annotation_maps = annotations.collect { |a| a.map }
      tag_maps = tags.collect { |t| t.map }
      @results = tag_maps.uniq
    #  @results = maps.concat(tag_maps).uniq
    end
    
    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @results }
    end
    
  end

end
