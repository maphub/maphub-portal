class Annotation < ActiveRecord::Base

  belongs_to :user, :counter_cache => true
  belongs_to :map
  
  validates_presence_of :body, :map

  def truncated_body
    if body.length > 30
      truncated_body = body[0, 30] + "..."
    else
      truncated_body = body
    end
    truncated_body
  end

end
