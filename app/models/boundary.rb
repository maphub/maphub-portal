class Boundary < ActiveRecord::Base
  
  # Model associations
  belongs_to :boundary_object, :polymorphic => true
  
  # updates map-based coordinates to real-world coordinates
  def recalc
    logger.debug "recalculating boundary #{self.inspect}"
    
    return unless self.ne_lat.nil? or self.ne_lng.nil? or self.sw_lat.nil? or self.sw_lng.nil?
    
    if boundary_object_type == "Annotation"
      cp = Annotation.find(boundary_object_id).map.control_points.first(3)
    elsif boundary_object_type == "Map"
      cp = Map.find(boundary_object_id).control_points.first(3)
    end
    
    self.ne_lat, self.ne_lng = ControlPoint.compute_latlng_from_known_xy(ne_x, ne_y, cp)
    self.sw_lat, self.sw_lng = ControlPoint.compute_latlng_from_known_xy(sw_x, sw_y, cp)
    self.save
    
  end
  
end
