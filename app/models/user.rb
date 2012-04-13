class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise:invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :authentications, :dependent => :delete_all  

  has_many :invitations, :class_name => self.class.to_s, :as => :invited_by

  has_one :circle
  has_many :memberships
  has_many :circle_memberships, :through => :memberships, :source => :circle

  has_many :jobs
  has_many :work_jobs, :class_name => "Job", :foreign_key => "worker_id"
  has_many :circle_jobs, :through => :circle_memberships, :source => :jobs
  
  validates :name, :email, :presence => true

  def apply_omniauth(auth)
    # In previous omniauth, 'user_info' was used in place of 'raw_info'
    self.name = auth['extra']['raw_info']['name']
    self.email = auth['extra']['raw_info']['email']
    self.location = auth['extra']['raw_info']['location']['name']
    
    # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end

  def to_s
    name
  end
  
  def potential_jobs
    self.circle_jobs.where('jobs.time > ? AND jobs.worker_id IS NULL', Time.now.localtime )
  end
  
  def upcoming_work_jobs
    self.work_jobs.where('jobs.time > ?', Time.now.localtime )
  end

  before_save :default_values
  def default_values
    #give 0 stars to start
    self.stars = 0 unless self.stars
    #create default circle on creation
    self.circle = Circle.new(:name => "Default Circle") unless self.circle
  end
  
end
