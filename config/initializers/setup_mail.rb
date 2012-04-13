ActionMailer::Base.smtp_settings = {
  :user_name => "app3681185@heroku.com",
  :password => "tht1ga6n",
  :domain => "circletime.herokuapp.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}