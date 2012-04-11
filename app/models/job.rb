class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :circle
  belongs_to :job_type, :include => :work_unit
  belongs_to :worker, :class_name => User

  def work_unit
    job_type.work_unit
  end
  
  def status
    if worker
      return "Taken by " + worker.name
    else
      return "Open"
    end
  end
  
  before_save :default_values
  def default_values
    #attach to default circle
    self.circle = self.user.circle unless self.circle
  end

end
