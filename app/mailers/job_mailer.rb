class JobMailer < ActionMailer::Base
  default :from => "PoppyGo Notifications <notifications@poppygo.com>"
  
  def invite_circle_to_job(new_job)
    @job = new_job
    @creator = @job.user
    @emails = @job.request_recipients(:select => :email).map(&:email)
    
    @url  = sign_up_for_job_path(@job)
    Rails.logger.info("---------MAILING A NEW JOB OUT TO CIRCLE---------!!!")
    mail(:to => @emails, :subject => "#{@creator.name} needs a #{@job.job_type.name}").deliver
  end  

  def thanks_for_taking_job(job,event)
    @job = job
    attachments['event.ics'] = { 
       :mime_type => 'text/calendar', 
       :content => event.export()
     }
    @email = "#{@job.worker.name} <#{@job.worker.email}>"
    mail(:to => @email, :subject => "Thanks for taking my #{@job.job_type.name} request #{@job.worker.first_name}. Save to your calendar! ").deliver
  end
  
  def notify_job_taken(job,event)
    @job = job
    attachments['event.ics'] = { 
       :mime_type => 'text/calendar', 
       :content => event.export()
     }
    @email = "#{@job.user.name} <#{@job.user.email}>"
    mail(:to => @email, :subject => "#{@job.worker.name} will do your #{@job.job_type.name} job").deliver
  end  
  
  def notify_job_closed(job)
    @job = job
    Rails.logger.info("---------#{@job}")
    @email = "#{@job.user.name} <#{@job.user.email}>,#{@job.worker.name} <#{@job.worker.email}>"
    mail(:to => @email, :subject => "#{@job.job_type.name} for <first name of job creater> completed on #{@job.endtime.to_date}").deliver
  end
  
  def notify_job_cancelled(job,worker)
    @job = job
    @worker = worker
    @email = "#{@job.user.name} <#{@job.user.email}>"
    mail(:to => @email, :subject => "#{worker.name} cancelled your #{@job.job_type.name} job").deliver
  end
  
end
