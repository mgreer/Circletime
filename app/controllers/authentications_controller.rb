class AuthenticationsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authentication
      # Authentication found, sign the user in.
      flash[:notice] = "Welcome back, #{authentication.user.first_name}"
      sign_in_and_redirect(:user, authentication.user)
    else
      # Authentication not found, thus a new user.
      test_user = User.new
      test_user.apply_omniauth(auth)
      # See if they got another form of invitation
      user = User.find_by_email( test_user.email )
      #if so use the invitation up
      if user && user.invitation_token
        user = User.accept_invitation!( :invitation_token => user.invitation_token, :name => test_user.name, :location => test_user.location )
        user.apply_omniauth(auth)
      #else just use the same user, and attach the authentication
      else
        user = test_user
      end
      if user.save(:validate => false)
        flash[:notice] = "Welcome to Circletime! <a href='#{url_for( new_user_invitation_path )}'>Add people</a> to start your network of favors.".html_safe
        sign_in_and_redirect(:user, user)
      else
        flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_url
      end
    end
  end
end
