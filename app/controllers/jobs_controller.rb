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
    @job.circle = current_user.circle
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

    respond_to do |format|
      if @job.save
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
    params[:job].parse_time_select! :time
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
end

module ActiveSupport
  class HashWithIndifferentAccess < Hash
    def parse_time_select!(attribute)
      self[attribute] = Time.zone.parse("#{self["#{attribute}(1i)"]}-#{self["#{attribute}(2i)"]}-#{self["#{attribute}(3i)"]} #{self["#{attribute}(4i)"]}:#{self["#{attribute}(5i)"]}#{self["#{attribute}(6i)"]}")
      (1..6).each { |i| self.delete "#{attribute}(#{i}i)" }
      self
    end
  end
end