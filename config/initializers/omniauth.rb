Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, "188343644605595", "a79e0b110812c55237c8b4d608c76428", {:scope => 'email, read_friendlists, user_location, offline_access'}
 
  # If you want to also configure for additional login services, they would be configured here.
end