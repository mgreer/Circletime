class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :circle
  belongs_to :job_type, :include => :work_unit
  belongs_to :worker, :class_name => User
  @event

  def work_unit
    job_type.work_unit
  end
  
  def date
    time.to_date
  end
  
  def hours
    duration * work_unit.hours
  end
  
  def status
    if worker
      worker.name + " will do it"
    else
      "Open"
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
