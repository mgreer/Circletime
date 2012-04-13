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

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job = Job.new
    @job_types = JobType.all
    #set type to default
    @job.job_type = @job_types[0]
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

    respond_to do |format|
      if @job.save
        JobMailer.invite_circle_to_job(@job).deliver
        format.html { redirect_to @job, :notice => 'Job was successfully created.' }
        format.json { render :json => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.json { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    #params[:job].parse_time_select! :time
    @job = Job.find(params[:id])

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
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :ok }
    end
  end

  # GET /jobs/1/sign_up
  def sign_up
    @job = Job.find(params[:id])
    Rails.logger.info("---------TAKING A JOB----------#{current_user}!!!")
    Rails.logger.info("   worker = #{@job.worker}")
    if @job.worker.nil?
      @job.worker = current_user
    end
    Rails.logger.info("   worker now = #{@job.worker}")
    respond_to do |format|
      if @job.save
        JobMailer.thanks_for_taking_job(@job).deliver
        JobMailer.notify_job_taken(@job).deliver
        format.html { redirect_to @job, :notice => 'You have been assigned to the job.' }
        format.json { render :json => @job, :status => :created, :location => @job }
      else
        format.html { redirect_to @job, :notice => 'There was an error in assiging you to this job.' }
        format.json { render :json => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

end

module ActiveSupport
  class HashWithIndifferentAccess < Hash
    def parse_time_select!(attribute)
      @date_string = "#{self["date"]} #{self["#{attribute}(4i)"]}:#{self["#{attribute}(5i)"]}#{self["#{attribute}(6i)"]}"
      Rails.logger.info("---------PARSING DATE FOR JOB----------!!!")
      Rails.logger.info( @date_string )
      Rails.logger.info("---------------------------------------!!!")
      self[attribute] = Time.zone.parse(@date_string)
      (1..6).each { |i| self.delete "#{attribute}(#{i}i)" }
    end
  end
end