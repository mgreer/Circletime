class Users::InvitationsController < Devise::InvitationsController

  # POST /resource/invitation
  def create
    self.resource = resource_class.invite!(params[resource_name], current_inviter)
    self.resource.memberships(params[:circle])

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      respond_with resource, :location => after_invite_path_for(resource)
    else
      respond_with_navigational(resource) { render :new }
    end
  end
  
end