class Users::InvitationsController < Devise::InvitationsController

  # POST /resource/invitation
  def create
    begin
      #create the user, with invite info
      self.resource = resource_class.invite!(params[resource_name], current_inviter)
      #add to the inviter's circle
      self.resource.memberships.create(:circle => current_inviter.circle)
    rescue
      logger.error { "throw an error about a duplicate membership invite" }
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      respond_with resource, :location => after_invite_path_for(resource)
    else
      respond_with_navigational(resource) { render :new }
    end
  end
  
end