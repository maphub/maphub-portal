class Tag < ActiveRecord::Base
  
  # Validation
  validates_presence_of :dbpedia_uri, :label
  
  # Model associations
  belongs_to :annotation
  
  # Pseudo functions
  def accepted?
    self.status == "accepted"
  end
  def rejected?
    self.status == "rejected"
  end
  def neutral?
    self.status == "neutral"
  end
 
end
