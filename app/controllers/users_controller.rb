class UsersController < ApplicationController
  before_filter :authenticate_user!
# before_filter :authenticate_user!, :only => [:edit, :update, :destroy]  
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end
  
  def welcome
    @user = current_user

    respond_to do |format|
      format.html # dashboard.html.erb
      format.json { render :json => @user }
    end
  end
  
  # GET /dashboard
  # GET //dashboard.json
  def dashboard
    @user = current_user
    @job_types = JobType.all()

    respond_to do |format|
      format.html # dashboard.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end
  
  # PUSH /facebook_friends/invite
  def fb_create
    @invitee = User.invite!({:email => params[:name].parameterize+"@test.com", :name => params[:name]}, current_user)
    if @invitee.errors.empty?
      @invitee.memberships.create(:circle => current_user.circle)
      Rails.logger.info("------------created #{@invitee}")
    end
    render :json => @invitee 
  end
  
  # GET /facebook_friends
  # GET /facebook_friends.json
  def facebook_friends
    @friends = current_user.fb_user.friends(:fields => "installed,name,id,picture,gender,email")
    @friends.sort! { |a,b| "#{!a.installed} #{a.name.downcase}" <=> "#{!b.installed} #{b.name.downcase}" }    
    respond_to do |format|
      format.html # facebook_friends.html.haml
      format.json { render :json => @friends }
    end
  end
  
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
