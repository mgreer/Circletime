class AuthenticationsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authentication
      Rails.logger.info("--------Authentication found, sign the user in.")
      flash[:notice] = "Welcome back, #{authentication.user.first_name}"
      sign_in_and_redirect(:user, authentication.user)
    else
      Rails.logger.info("--------Authentication not found, maybe a new user.")
      test_user = User.new
      test_user.apply_omniauth(auth)
      Rails.logger.info("----------See if we know this user already...")
      Rails.logger.info("---------- Does their email exist?")
      user = User.find_by_email( test_user.email )
      if user && user.invitation_token
        Rails.logger.info("----------Yes, they were invited, use the invitation up.")
        user = User.accept_invitation!( :invitation_token => user.invitation_token, :name => test_user.name, :location => test_user.location )
        user.apply_omniauth(auth)
      elsif user
        Rails.logger.info("------------ Yes, attach auth to that user for future signin")
        user.apply_omniauth(auth)        
      else
        Rails.logger.info("------------ No, it is a new user entirely")
        user = test_user
      end
      if user.save(:validate => false)
        flash[:notice] = "Welcome to Poppy! <a href='#{url_for( new_user_invitation_path )}'>Add people</a> to start your network of favors.".html_safe
        sign_in(:user, user)
        redirect_to :welcome
      else
        flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_url
      end
    end
  end
end
