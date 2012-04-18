class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :circle
  belongs_to :job_type, :include => :work_unit
  belongs_to :worker, :class_name => User
  @event

  WAITING = 0
  ASSIGNED = 1
  CLOSED = 2

  def work_unit
    job_type.work_unit
  end
  
  def date
    time.to_date
  end
  
  def hours
    duration * work_unit.hours
  end
  
  def status_msg
    if worker
      worker.name + " will do it"
    elsif status == Job::CLOSED
      "Job completed"
    else
      "Sent out and waiting"
    end
  end
  
  def to_s
    "#{job_type.name} for #{user.name}"
  end
  
  before_save :default_values
  def default_values
    #attach to default circle
    self.circle = self.user.circle unless self.circle
    
  end

end
