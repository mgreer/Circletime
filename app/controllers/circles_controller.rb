class CirclesController < ApplicationController
  before_filter :authenticate_user!
  # GET /circles
  # GET /circles.json
  def index
    @circle = current_user.circle

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @circle }
    end
  end

  # GET /circles/1
  # GET /circles/1.json
  def show
    @circle = Circle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @circle }
    end
  end

  # GET /circles/new
  # GET /circles/new.json
  def new
    @circle = Circle.new
    @circle.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @circle }
    end
  end

  # GET /circles/1/edit
  def edit
    @circle = Circle.find(params[:id])
  end

  # POST /circles
  # POST /circles.json
  def create
    @circle = Circle.new(params[:circle])
    @circle.user = current_user
    
    respond_to do |format|
      if @circle.save
        format.html { redirect_to @circle, :notice => 'Circle was successfully created.' }
        format.json { render :json => @circle, :status => :created, :location => @circle }
      else
        format.html { render :action => "new" }
        format.json { render :json => @circle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /circles/1
  # PUT /circles/1.json
  def update
    @circle = Circle.find(params[:id])

    respond_to do |format|
      if @circle.update_attributes(params[:circle])
        format.html { redirect_to @circle, :notice => 'Circle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @circle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /circles/1
  # DELETE /circles/1.json
  def destroy
    @circle = Circle.find(params[:id])
    @circle.destroy

    respond_to do |format|
      format.html { redirect_to circles_url }
      format.json { head :no_content }
    end
  end
  
  # POST /circles/member/1
  # POST /circles/member/1.js
  def add_member
    @member = User.find(params[:id])
    current_user.add_member( @member )
    if current_user.circle.save
      respond_to do |format|
         format.html { redirect_to :back, :notice => 'Successfully added your friend to your circle.'.html_safe }
         format.js { }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, :error => 'Error adding them to circle.'}
        format.js { render :text => "Error adding #{@member.first_name} to your circle." }
      end
    end   
  end

  # DELETE /circles/member/1
  def remove_member
    @member = User.find(params[:id])
    current_user.circle.users.delete( @member )
    if current_user.circle.save
      redirect_to :back, :notice => 'Successfully removed your friend from your circle.'.html_safe
    else
      redirect_to :back, :error => 'Error removing them from your circle.'
    end   
  end

end
