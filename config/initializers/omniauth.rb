Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  if (ENV['RAILS_ENV']=='development')
    provider :facebook, "188343644605595", "a79e0b110812c55237c8b4d608c76428", {:scope => 'email, read_friendlists, user_location, offline_access'}
  elsif (ENV['RAILS_ENV']=='production')
    provider :facebook, "329040470488973", "e44f23502404b62547bb0a7b798615c9", {:scope => 'email, read_friendlists, user_location, offline_access'}
  end
  # If you want to also configure for additional login services, they would be configured here.
end