class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :fullname, :username, :email, :password, :password_confirmation, :remember_me, :about_me
  
  # Default scope (inactive users are filtered out)
  default_scope :conditions => {:deleted_at => nil}
  
   # Unique attributes
  validates_uniqueness_of :username
  
  # Hooks
  after_create :send_sign_up_notification
  
  # Model associations
  has_many :maps
  has_many :collections
  has_many :annotations
  
  
  def self.find_with_destroyed *args
    self.with_exclusive_scope { find(*args) }
  end
  
  def deactivate
    begin
      # update_attribute(:email, nil)
      # update_attribute(:username, "deleted user")
      update_attribute(:deleted_at, Time.current)
    end
  end
  
private

  def send_sign_up_notification 
    begin
      
    rescue Errno::ECONNREFUSED => e
      logger.warn("Failed to send mail to user. #{e}")
      # this happens when the email is not correct - it's the users own fault, so leave it like that.
    end
  end 
  
end
