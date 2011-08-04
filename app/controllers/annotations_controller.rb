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
    end
  end

  # GET /annotations/1
  # GET /annotations/1.xml
  def show
    @annotation = Annotation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @annotation }
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
    @annotation.creation_date = DateTime.now
    @annotation.edit_date = DateTime.now
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
    @annotation.edit_date = DateTime.now
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
    @annotation.destroy

    respond_to do |format|
      format.html { redirect_to(annotations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_parent
    @parent ||= case
      when params[:user_id] then User.find(params[:user_id])
      when params[:map_id] then Map.find(params[:map_id])
    end
  end
end
