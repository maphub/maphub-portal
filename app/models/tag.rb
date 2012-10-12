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
  
  #Virtual Attribute
  def wikipedia_uri
    "#{dbpedia_uri}".gsub("dbpedia.org/resource", "wikipedia.org/wiki")    
  end
  
  def google_that_uri
    "http://lmgtfy.com/?q=" + "#{label}".gsub(" ", "+") + "&l=1"
  end
 
end
