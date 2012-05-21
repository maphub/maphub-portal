class Boundary < ActiveRecord::Base
  
  belongs_to :boundary_object, :polymorphic => true
  
  def convert_to_latlng
    
  end
  
end
