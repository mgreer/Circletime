class Users::InvitationsController < Devise::InvitationsController

  # POST /resource/invitation
  def create
    #for each email
    Rails.logger.info("-------emails: #{params[:user_email]}")
    @inviter = current_inviter
    params[:user_email].each do |email|
      Rails.logger.info("---------invite #{email}")
      #find if there is a current user
      @invitee = User.where(:email => email).first
      if @invitee 
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
    
    flash[:notice] = "You successfully invited #{params[:user_email].size} friends to your circle."
    respond_with_navigational(resource) { render :new }
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
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