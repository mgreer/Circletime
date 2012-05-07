Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, FACEBOOK_APP_ID, FACEBOOK_TOKEN, {:scope => 'email, read_friendlists, user_location, offline_access'}
  # If you want to also configure for additional login services, they would be configured here.
end