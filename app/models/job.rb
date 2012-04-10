class Job < ActiveRecord::Base
  belongs_to :user
  has_many :applications
  belongs_to :circle
  belongs_to :job_type, :include => :work_unit

  def work_unit
    job_type.work_unit
  end
  
  before_save :default_values
  def default_values
    #attach to default circle
    self.circle = self.user.circle unless self.circle
  end
  
     
end
