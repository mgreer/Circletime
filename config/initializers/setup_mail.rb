ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
#  :domain               => "railscasts.com",
  :user_name            => "michael.greer",
  :password             => "osip100",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "my.localhost.com:3000"
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?