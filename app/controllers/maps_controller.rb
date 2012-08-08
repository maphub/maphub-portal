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
    if(current_user.condition_assignment == nil)
      session[:conditions] = ['manual-entry', 'user-suggest', 'semantic-tagging', 'semantic-tagging-wiki'].shuffle!
      session[:count] = 0
      session[:user_id] = current_user.id
      current_user.update_attribute(:condition_assignment, session[:conditions].join(", "))
          current_user.save!
    end
    
    condition_completed = 
    (current_user.annotations.find_by_condition session[:conditions][session[:count]]) != nil
    if(condition_completed) 
      session[:count] = session[:count]+1
    end
    @current_condition = session[:conditions][session[:count]]
    
    #logger.debug("ARRAY IS: " + session[:conditions].to_s)
    #logger.debug("COUNT IS: " + session[:count].to_s)
    #logger.debug("CURRENT VALUE IS: " + @current_condition)
    #logger.debug("COMPLETED IS: " + condition_completed.to_s)
    
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

  def test
    render :show
  end
      
end
