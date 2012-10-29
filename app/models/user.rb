class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise:invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  audited :protect => false
  has_associated_audits

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :location, :timezone_offset
  
  has_many :authentications, :dependent => :delete_all  

  has_many :invitations, :class_name => self.class.to_s, :as => :invited_by

  has_many :transactions

  has_one :circle, :dependent => :delete
  has_many :memberships, :dependent => :delete_all
  has_many :circle_memberships, :through => :memberships, :source => :circle

  has_many :job_requests, :through => :recipients, :source => :job

  has_many :jobs
  has_many :work_jobs, :class_name => "Job", :foreign_key => "worker_id"
  has_many :circle_jobs, :through => :circle_memberships, :source => :jobs
  
  validates :name, :email, :presence => true

  INVITED = 0
  AUTHORIZED = 1
  
  TZ_MAPPING = {
    -5=> "Eastern Time (US & Canada)",
    -6=> "Central Time (US & Canada)",
    -7=> "Mountain Time (US & Canada)",
    -8=> "Pacific Time (US & Canada)",
    -9=> "Alaska",
    -10=> "Hawaii"
  }

  def apply_omniauth(auth)
    # In previous omniauth, 'user_info' was used in place of 'raw_info'
    self.name = auth['extra']['raw_info']['name']
    self.email = auth['extra']['raw_info']['email']
    self.location = auth['extra']['raw_info']['location']['name']
    self.timezone_offset = auth['extra']['raw_info']['timezone']
    
    # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end

  def to_s
    name
  end
  
  def status
    if self.invitation_token
      INVITED
    else 
      AUTHORIZED
    end
  end
  
  def first_name
    return self.name.split(' ', 2)[0]
  end
  
  def last_name
    return self.name.split(' ', 2)[1]
  end
  
  #add a member to the circle
  def add_member(member)
    Rails.logger.info("------------adding #{member} to circle")
    if !self.circle.users.include?( member )
      member.memberships.create(:circle => self.circle)
      UserMailer.notify_added_to_circle(self,member).deliver
      #send email
    else
      Rails.logger.info("--------------already a member!")      
    end
  end
  
  def timezone
    unless self.timezone_offset.nil? || !TZ_MAPPING.key?( self.timezone_offset )
      TZ_MAPPING.fetch( self.timezone_offset )
    else
      TZ_MAPPING.fetch( -8 )
    end
  end
  
  def future_taken_jobs
    self.jobs.where('jobs.time > ? AND worker_id IS NOT NULL', Time.now.localtime )
  end

  def future_open_jobs
    self.jobs.where('jobs.time > ? AND worker_id IS NULL', Time.now.localtime )
  end
  
  def potential_jobs
    @jobs = self.circle_jobs.where('jobs.time > ? AND jobs.worker_id IS NULL', Time.now.localtime )
    @unseen_jobs = []
    @jobs.each do |job|
      unless job.turned_down_by( self )
        @unseen_jobs.push(job)
      end
    end
    @unseen_jobs
  end
  
  def latest_job
    self.jobs.last
  end
  
  def upcoming_work_jobs
    self.work_jobs.where('jobs.time > ?', Time.now.localtime )
  end

  def upcoming_jobs
    @jobs = future_taken_jobs + upcoming_work_jobs
    @jobs.sort! { |a,b| a.time <=> b.time }
  end

  before_save :default_values
  def default_values
    #give 3 stars to start
    self.stars = 3 unless self.stars
    #create default circle on creation
    self.circle = Circle.new(:name => "Default Circle") unless self.circle
  end

  def fb_user
    facebook = authentications.where(:provider => :facebook).first
    ::FbGraph::User.fetch facebook.uid, :access_token => facebook.token
  end

  #overriding from devise:invitable
  def accept_invitation!    
    super
    #add to the inviter's circle
    @inviter = self.invited_by
    Rails.logger.info("---------adding invitee to #{@inviter.circle} ")
#    @inviter.circle.users.create( self )
#    @inviter.circle.save()
    self.memberships.create(:circle => self.invited_by.circle)
    #and inverse
    Rails.logger.info("---------adding inviter to new circle")
    self.invited_by.memberships.create(:circle => self.circle)    
    UserMailer.notify_accepted_invitation(@inviter,self)
#    self.circle.users.create( @inviter ) 
#    self.circle.save() 
  end  
  protected  
    def deliver_invitation
      UserMailer.invitation_instructions(self).deliver
    end
end
