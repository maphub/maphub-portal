class Tag < ActiveRecord::Base
  
  belongs_to :map
  
  validates_presence_of :dbpedia_uri, :label
  
end
