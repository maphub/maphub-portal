class ControlPointsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :get_parent

  # GET /control_points
  # GET /control_points.xml
  # GET /user/:user_id/control_points
  # GET /user/:user_id/control_points.xml  
  # GET /map/:map_id/control_points
  # GET /map/:map_id/control_points.xml  
  def index
    
    unless @parent.nil?
      @control_points = @parent.control_points
    else
      @control_points = ControlPoint.all
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @control_points }
      format.json { render :json => @control_points }
    end
  end

  # GET /control_points/1
  # GET /control_points/1.xml
  def show
    @control_point = ControlPoint.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @control_point }
      format.json { render :json => @control_point }
    end
  end

  # GET /control_points/new
  # GET /control_points/new.xml
  # GET /maps/:map_id/control_points/new
  def new
    @map = Map.find(params[:map_id])
    @control_point = @map.control_points.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @control_point }
    end
  end

  # GET /control_points/1/edit
  def edit
    @control_point = ControlPoint.find(params[:id])
  end

  # POST /control_points
  # POST /control_points.xml
  def create
    @control_point = ControlPoint.new(params[:control_point])
    @control_point.user = current_user
    @control_point.map = Map.find(params[:map_id])
    @map = @control_point.map # we have to do this so the form is correctly displayed on error
    respond_to do |format|
      if @control_point.save
        format.html { redirect_to(@control_point, :notice => 'Control Point was successfully created.') }
        format.xml  { render :xml => @control_point, :status => :created, :location => @control_point }
        format.js { }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @control_point.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /control_points/1
  # PUT /control_points/1.xml
  def update
    @control_point = ControlPoint.find(params[:id])
    respond_to do |format|
      if @control_point.update_attributes(params[:control_point])
        format.html { redirect_to(@control_point, :notice => 'Control Point was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @control_point.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /control_points/1
  # DELETE /control_points/1.xml
  def destroy
    @control_point = ControlPoint.find(params[:id])
    @map = @control_point.map
    @control_point.destroy

    respond_to do |format|
      format.html { redirect_to(map_url @map) }
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
