class JobsController < ApplicationController

  before_filter :authenticate_user!
  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = current_user.jobs

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @job }
    end
  end

  # GET /jobs/1/details
  def details
    @job = Job.find(params[:id])
    render :partial => "detail", :layout => false
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job = Job.new
    @job.time = Time.zone.now().advance(:hours => 1,:days => 1)
    @job_types = JobType.all
    @job.circle = current_user.circle
    #set type to default
    unless params[ :job_type_id ].nil?
      @job.job_type = JobType.find( params[ :job_type_id ] )
    else
      #choose same type as last job if there is one
      unless current_user.latest_job.nil?
        @job.job_type = current_user.latest_job.job_type
      else
        @job.job_type = @job_types[0]
      end
    end
    #set default stars to job_type default
    @job.stars = @job.job_type.stars

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    @job_types = JobType.all
  end

  # POST /jobs
  # POST /jobs.json
  def create
    params[:job].parse_time_select! :time

    @job = Job.new(params[:job])
    @job.user = current_user
    @job.circle = current_user.circle
    @job.status = Job::WAITING
    @job.endtime =  @job.time.advance(:hours => @job.hours)

    respond_to do |format|
      if @job.save  
        @job.mark_created()        
        JobMailer.invite_circle_to_job(@job).deliver
        format.html { redirect_to @job, :notice => 'Job was successfully created.' }
        format.json { render :json => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.json { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  #GET /jobs/1/invite
  def send_invites
    @job = Job.find(params[:id])
    unless current_user == @job.user
      return
    end
    JobMailer.invite_circle_to_job(@job).deliver
    Rails.logger.info("--------invites sent out again")
    @invites = @job.circle.users.map{ |r| "#{r.name}" }.join ', '
    redirect_to :dashboard, :notice => 'We sent out invites again to '+@invites
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    params[:job].parse_time_select! :time
    @job = Job.find(params[:id])
    @job.endtime = @job.time.advance(:hours => @job.hours)
    Rails.logger.info("---------Updating job #{@job.time}->#{@job.endtime}")    
 
    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to @job, :notice => 'Job was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    #TODO: Notify worker if there is one
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :ok }
    end
  end

  # PUT /jobs/1/turndown
  # PUT /jobs/1/turndown.json
  def turndown
    @job = Job.find(params[:id])
    @job.mark_turneddown(current_user)

    respond_to do |format|
      format.html { redirect_to :dashboard, :notice => "You turned down #{@job.user}'s job." }
      format.json { head :ok }
    end
  end


  # GET /jobs/1/cancel
  def cancel_assignment
    @job = Job.find(params[:id])
    #make sure user can do this
    if @job.status != Job::ASSIGNED || @job.worker.nil? || @job.worker != current_user
      Rails.logger.info("--------not entitled to cancel this job")
      redirect_to :dashboard, :notice => 'You are not assigned to this job.'
      return
    end
    #remove worker from job
    @job.worker = nil
    @job.status = Job::WAITING
    #Cancel event?
    #Send out again?
    respond_to do |format|
      if @job.save
        @job.mark_cancelled() 
        #Notify owner if there is one
        JobMailer.notify_job_cancelled(@job,current_user).deliver
        format.html { redirect_to :dashboard, :notice => 'You have cancelled the job. Thanks for nothin.' }
        format.json { render :json => @job, :status => :created, :location => @job }
      else
        format.html { redirect_to :dashboard, :notice => 'There was an error in cancelling this job.' }
        format.json { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /jobs/1/sign_up
  def sign_up
    @job = Job.find(params[:id])
    Rails.logger.info("---------TAKING A JOB----------#{current_user}!!!")
    Rails.logger.info("   worker = #{@job.worker}")
    if @job.worker.nil?
      @job.worker = current_user
      Rails.logger.info("   worker now = #{@job.worker}")
      @event = RiCal.Calendar do |cal|
        cal.event do |event|      
          event.add_x_property 'X-GOOGLE-CALENDAR-CONTENT-TITLE', @job.to_s
          event.description = @job.to_s
          event.summary =     @job.to_s
          if @job.job_type.work_unit.hours > 23
            event.dtstart =   @job.time.to_date
            unless @job.job_type.is_misc
              event.dtend =   @job.endtime
            end
          else
            event.dtstart =   @job.time
          end
          unless @job.user.location.nil?
            event.location =    @job.user.location
          end
          event.add_attendee  @job.worker.email
          event.add_attendee  @job.user.email
          event.organizer =   @job.user.email
        end
      end
      @job.status = Job::ASSIGNED
      respond_to do |format|
        if @job.save
          @job.mark_accepted() 
          JobMailer.thanks_for_taking_job(@job,@event).deliver
          JobMailer.notify_job_taken(@job,@event).deliver
          format.html { redirect_to @job, :notice => 'You have been assigned to the job.' }
          format.json { render :json => @job, :status => :created, :location => @job }
        else
          format.html { redirect_to @job, :notice => 'There was an error in assiging you to this job.' }
          format.json { render :json => @job.errors, :status => :unprocessable_entity }
        end
      end
    else  
      respond_to do |format|
        format.html { redirect_to @job, :notice => 'This job has already been taken by another' }
        format.json { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  #TODO: Should be post
  # GET /jobs/open/close
  def close_open_jobs
    @jobs = Job.close_open_jobs
    render :json => @jobs
  end

end

module ActiveSupport
  class HashWithIndifferentAccess < Hash
    def parse_time_select!(attribute)
      @date_string = "#{self["#{attribute}(1i)"]} #{self["#{attribute}(2i)"]}:#{self["#{attribute}(3i)"]}#{self["#{attribute}(4i)"]}"
      Rails.logger.info("---------PARSING DATE FOR JOB----------!!!")
      Rails.logger.info( @date_string )
      Rails.logger.info("---------------------------------------!!!")
      @new_time = Time.zone.parse(@date_string)
      Rails.logger.info( @new_time )
      Rails.logger.info("---------------------------------------!!!")
      self[attribute] = @new_time
      (1..6).each { |i| self.delete "#{attribute}(#{i}i)" }
    end
  end
end