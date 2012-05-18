class AnnotationsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :get_parent

  # GET /annotations
  # GET /annotations.xml
  # GET /user/:user_id/annotations
  # GET /user/:user_id/annotations.xml  
  # GET /map/:map_id/annotations
  # GET /map/:map_id/annotations.xml  
  def index
    unless @parent.nil?
      @annotations = @parent.annotations
    else
      @annotations = Annotation.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @annotations }
      format.json { 
        # prepare for JSON view, we need to sanitize
        @annotations.each do |a| 
          a.body = ERB::Util::html_escape a.body
          a.body = ActionController::Base.helpers.simple_format a.body
        end
        render :json => @annotations 
      }
    end
  end

  # GET /annotations/1
  # GET /annotations/1.xml
  def show
    @annotation = Annotation.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @annotation }
      format.json { render :json => @annotation } 
      format.rdf  {render :rdf => @annotation, :httpURI => base_uri(request.url)}
      format.ttl  {render :ttl => @annotation, :httpURI => base_uri(request.url)}
      format.nt  {render :nt => @annotation, :httpURI => base_uri(request.url)}
    end
  end

  # GET /annotations/new
  # GET /annotations/new.xml
  # GET /maps/:map_id/annotations/new
  def new
    @map = Map.find(params[:map_id])
    @annotation = @map.annotations.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @annotation }
    end
  end

  # GET /annotations/1/edit
  def edit
    @annotation = Annotation.find(params[:id])
  end

  # POST /annotations
  # POST /annotations.xml
  def create
    @annotation = Annotation.new(params[:annotation])
    unless params[:label].nil?
      params[:label].zip(params[:dbpedia_uri]).each do |label, dbpedia_uri|
        tag = @annotation.tags.build(:label => label, :dbpedia_uri => dbpedia_uri)
      end
    end
    @annotation.user = current_user
    @annotation.map = Map.find(params[:map_id])
    @map = @annotation.map # we have to do this so the form is correctly displayed on error
    respond_to do |format|
      if @annotation.save
        format.html { redirect_to(@annotation, :notice => 'Annotation was successfully created.') }
        format.xml  { render :xml => @annotation, :status => :created, :location => @annotation }
        format.js { }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @annotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /annotations/1
  # PUT /annotations/1.xml
  def update
    @annotation = Annotation.find(params[:id])
    respond_to do |format|
      if @annotation.update_attributes(params[:annotation])
        format.html { redirect_to(@annotation, :notice => 'Annotation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @annotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /annotations/1
  # DELETE /annotations/1.xml
  def destroy
    @annotation = Annotation.find(params[:id])
    @map = @annotation.map
    @annotation.destroy

    respond_to do |format|
      format.html { redirect_to(map_url @map) }
      format.xml  { head :ok }
    end
  end
  
  # GET /maps/1/annotations/tags/:text/(optional boundaries)
  def tags
    # empty return container for tags
    ret = []
    
    # 1) find tags from the raw text
    ret = ret.concat Annotation.find_tags_from_text(params[:text])
    
    # 2) find tags from the boundaries of the annotation, relative to this map
    ret = ret.concat Annotation.find_tags_from_boundary(Map.find(params[:map]), params[:boundary_bottom], params[:boundary_left], params[:boundary_right], params[:boundary_top])
    
    # return JSON of tags
    render :json => ret.to_json
  end
  
  private
  
  def get_parent
    @parent ||= case
      when params[:user_id] then User.find(params[:user_id])
      when params[:map_id] then Map.find(params[:map_id])
    end
  end
end
