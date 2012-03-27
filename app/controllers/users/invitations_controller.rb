class Users::InvitationsController < Devise::InvitationsController

  # POST /resource/invitation
  def create
    #create the user, with invite info
    self.resource = resource_class.invite!(params[resource_name], current_inviter)
    #add to the inviter's circle
    @membership = self.resource.memberships.create(:circle => current_inviter.circle)

    if resource.errors.empty? and @membership.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      respond_with resource, :location => after_invite_path_for(resource)
    else
      respond_with_navigational(resource) { render :new }
    end
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
  
end