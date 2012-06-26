class Tag < ActiveRecord::Base
  
  # Search
  searchable do
    text :label, :boost => 3.0
    text :enrichment
  end
  
  # Validation
  validates_presence_of :dbpedia_uri, :label, :enrichment
  :selected
  
  # Model associations
<<<<<<< HEAD
  belongs_to :map
<<<<<<< HEAD
  
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
  

=======
>>>>>>> Finished semantic tag enrichment
  belongs_to :annotation

end
