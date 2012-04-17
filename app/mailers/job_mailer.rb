class JobMailer < ActionMailer::Base
  default :from => "Circletime Notifications <notifications@circletime.com>"
  
  def invite_circle_to_job(new_job)
    @job = new_job
    @creator = @job.user
    @emails = @job.circle.users(:select => :email).map(&:email)
    
    @url  = sign_up_for_job_path(@job)
    Rails.logger.info("---------MAILING A NEW JOB OUT TO CIRCLE---------!!!")
    mail(:to => @emails, :subject => "#{@creator.name} needs a #{@job.job_type.name}")
  end  

  def thanks_for_taking_job(job,event)
    @job = job
    unless @job.job_type.is_misc
      attachments['event.ics'] = { 
         :mime_type => 'text/calendar', 
         :content => event.export()
       }
    end
    @email = "#{@job.worker.name} <#{@job.worker.email}>"
    mail(:to => @email, :subject => "Thanks for handling my #{@job.job_type.name} job!")
  end
  
  def notify_job_taken(job,event)
    @job = job
    unless @job.job_type.is_misc
      attachments['event.ics'] = { 
         :mime_type => 'text/calendar', 
         :content => event.export()
       }
    end
    @email = "#{@job.user.name} <#{@job.user.email}>"
    mail(:to => @email, :subject => "#{@job.worker.name} will do your #{@job.job_type.name} job")
  end  
  
  
end
