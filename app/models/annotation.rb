class Annotation < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  validates_presence_of :title, :map
  
  searchable do
    text :title, :default_boost => 2
    text :body
  end
  
end
