class Users::InvitationsController < Devise::InvitationsController

  # GET /resource/invitation/new
  def new
    build_resource
    @email = params[:user_email]
    render :new
  end

  # POST /resource/invitation
  def create
    #for each email
    Rails.logger.info("-------emails: #{params[:user_email]}")
    @inviter = current_inviter
    params[:user_email].each do |email|
      Rails.logger.info("---------invite #{email}")
      #find if there is a current user
      @invitee = User.where(:email => email).first
      if @invitee && @invitee.invitation_token.nil?
        Rails.logger.info("------------#{email} exists already, adding #{@invitee} to circle")
        current_inviter.add_member(@invitee)
      else @invitee        
        #if not, create them with invite info
        Rails.logger.info("------------creating #{email}")
        @invitee = User.invite!({:email => email}, current_inviter)
        if @invitee.errors.empty?
          @invitee.memberships.create(:circle => current_inviter.circle)
          Rails.logger.info("------------created #{@invitee}")
        end
      end
      #add to the inviter's circle
      @invitee.memberships.create(:circle => current_inviter.circle)
      #and inverse
      current_inviter.memberships.create(:circle => @invitee.circle)
    end
    
    flash.now[:notice] = "Your invitation has been sent to #{params[:user_email].size} friends."
    respond_with_navigational(resource) { render :create }
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(params[resource_name])

    if resource.errors.empty?
      flash[:notice] = "Congratulations! You started your network and have 1 person in it. <a href='#{url_for( new_user_invitation_path )}'>Add people</a> to start your network of favors.".html_safe
      sign_in(resource_name, resource)
      respond_with resource, :location => :dashboard
    else
      respond_with_navigational(resource){ render :edit }
    end
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
end