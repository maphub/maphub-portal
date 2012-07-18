class AnnotationsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :get_parent, :get_base_uri, :get_host

  # GET /annotations
  # GET /annotations.xml
  # GET /user/:user_id/annotations
  # GET /user/:user_id/annotations.xml  
  # GET /map/:map_id/annotations
  # GET /map/:map_id/annotations.xml  
  def index
    unless @parent.nil?
      @annotations = @parent.annotations.order(:updated_at).page(params[:page]).per(10)
      @all_annotations = @parent.annotations
    else
      @annotations = Annotation.order(:updated_at).page(params[:page]).per(10)
      @all_annotations = Annotation.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @all_annotations }
      format.json { 
        # prepare for JSON view, we need to sanitize
        @all_annotations.each do |a| 
          a.body = ERB::Util::html_escape a.body
          a.body = ActionController::Base.helpers.simple_format a.body
        end
        render :json => @all_annotations.to_json(:methods => [:google_maps_annotation]) 
      }
      format.rdf
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
      format.rdf  { render :rdf => @annotation, 
                           :httpURI => @base_uri,
                           :host => @host}
      format.ttl  { render :ttl => @annotation, 
                           :httpURI => @base_uri,
                           :host => @host}
      format.nt   { render :nt => @annotation, 
                           :httpURI => @base_uri,
                           :host => @host}
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
    #@boundary = Boundary.new(params[:boundary])
    
    @annotation = Annotation.new(params[:annotation])
    
    # create tags from plain form fields
    unless params[:label].nil?
      [params[:label], params[:dbpedia_uri], params[:description], params[:status]].transpose.each do |label, dbpedia_uri, description, status|
        tag = @annotation.tags.build(
        :label => label, 
        :dbpedia_uri => dbpedia_uri,
        :description => description,
        :status => status
        )
      end
    end
    
    # associate user and map
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
    
    if current_user == @annotation.user
      @annotation.destroy
    end
    
    @map.solr_index!

    respond_to do |format|
      format.html { redirect_to(map_url @map) }
      format.xml  { head :ok }
    end
  end
  
  # GET /maps/1/annotations/tags?text=text&(optional boundaries)
  def tags
    # 1) find tags from the raw text
    ret = Annotation.find_tags_from_text(params[:text])
    
    # 2) find tags from the boundaries of the annotation, relative to this map
    map = Map.find(params[:map])
    boundary = Boundary.new(params[:annotation]["boundary"])
    ret = ret.concat Annotation.find_tags_from_boundary(map, boundary)
    
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
