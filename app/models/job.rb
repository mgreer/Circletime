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
  
  def time_in_zone
    time.in_time_zone( self.user.timezone )
  end
  
  def date
    time.to_date
  end
  
  def end_date
    
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
    #waiting at the beginning
    self.status = Job::WAITING unless self.status
  end

  def self.close_open_jobs
    #find open but completed jobs
    Rails.logger.info("---------LOOKING FOR ASSIGNED JOBS TO CLOSE----------!!!")
    @jobs = Job.where("jobs.status = ? AND jobs.endtime < ?", Job::ASSIGNED, Time.zone.now.localtime )
    @jobs.each do |job|
      Rails.logger.info("-------closing #{job}")
      Rails.logger.info("---------moving #{job.stars} stars from #{job.user.name} to #{job.worker.name}")
      job.user.stars -= job.stars
      job.worker.stars += job.stars      
      Rails.logger.info("---------sending email to #{job.user.email}")
      Rails.logger.info("---------sending email to #{job.worker.email}")
      JobMailer.notify_job_closed(job).deliver
      Rails.logger.info("---------setting to CLOSED")      
      job.status = Job::CLOSED
      Rails.logger.info("---------saving...")
      begin
        job.user.save
        job.worker.save
        job.save        
      rescue Exception => e
        Rails.logger.error("---------PROBLEM SAVING: #{e}")              
      end
      Rails.logger.info("---------DONE")    
    end
    @jobs
  end
  
end
