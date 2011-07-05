class Map < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  has_many :annotations
  has_and_belongs_to_many :collections
  
end
