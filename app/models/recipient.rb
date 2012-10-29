class Recipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  audited :associated_with => :job

  attr_accessible :job,:user
    
  validates :user_id, :uniqueness => { :scope => :job_id, :message => "Can only add the user to the job once" }
  
  def to_s
    user.name + " is being asked to do a job by " + job.user.name
  end

end
