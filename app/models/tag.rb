class Tag < ActiveRecord::Base
  
  # Validation
  validates_presence_of :dbpedia_uri, :label
  
  # Model associations
  belongs_to :map
  
  
end
