class MapsController < ApplicationController
  
  before_filter :get_base_uri
  
  # Show all maps
  def index
    @maps = Map.order(:updated_at).page(params[:page]).per(20) 
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => Map.all }
      format.json { render :json => Map.all.to_json(:only =>[:id,:updated_at], :methods => [:no_control_points]) }
    end
  end
  
  # Render a single map
  def show
    @map = Map.find(params[:id])
    a = 'manual-entry'
    b = 'user-suggest'
    c = 'semantic-tagging'
    d = 'semantic-tagging-wiki'
    conditions = [[a, b, d, c], [b, c, a, d], [c, d, b, a], [d, a, c, b]] 
    if(current_user != nil)

      #Assigns 4 users to each condition treatment
      condition_num = (current_user.id/4)%4
      
      assignment = []
      (0..3).each do |i|
        assignment << conditions[condition_num][(i + current_user.id)%4]
      end      
     
      current_user.update_attribute(:condition_assignment, assignment.join(", "))

      #Starts each of the 4 users on a different index in the condition array
      annotation_num = (current_user.annotations.count + current_user.id)%4
      session[:condition] = conditions[condition_num][annotation_num]
     
    else
      #Condition for when user isn't logged in
      session[:condition] = 'semantic-tagging-wiki'
    end
    @current_condition = session[:condition]
    
    respond_to do |format|
      format.html # show.html.erb
      format.rdf  # show.rdf.erb
      format.kml {
        kml_data = open(@map.kml_uri).read
        send_data kml_data, :type => :kml, :filename => "#{@map.identifier}.kml"
      }
      format.json {
        map = {
          id: @map.id,
          identifier: @map.identifier,
          subject: @map.subject,
          title: @map.title,
          author: @map.author,
          date: @map.date,
          height: @map.height,
          width: @map.width,
          updated_at: @map.updated_at,
          created_at: @map.created_at,
          thumbnail_uri: @map.thumbnail_uri,
          tileset_uri: @map.tileset_uri
        }
        
        if @map.has_overlay?
          map[:overlay_tileset_uri] = @map.overlay_tileset_uri
          overlay_boundary = @map.overlay_boundary
          map[:overlay_boundary] = {
            sw_lat: overlay_boundary.sw_lat,
            sw_lng: overlay_boundary.sw_lng,
            ne_lat: overlay_boundary.ne_lat,
            ne_lng: overlay_boundary.ne_lng
          }
        end
        
        if @map.control_points.count > 0
          map[:controlpoints] = []
          @map.control_points.each do |cp|
            map[:controlpoints] << {
              lat: cp.lat,
              lng: cp.lng,
              x: cp.x,
              y: cp.y
            }
          end
        end
        
        map[:boundary] = {
          sw_lat: @map.boundary.sw_lat,
          sw_lng: @map.boundary.sw_lng,
          ne_lat: @map.boundary.ne_lat,
          ne_lng: @map.boundary.ne_lng
        }
        
        render :json => JSON.pretty_generate(map)
      }
    end
  end
      
end
