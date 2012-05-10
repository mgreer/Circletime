class UserMailer < ActionMailer::Base
  default :from => "Circletime Notifications <notifications@circletime.com>"
  
  def notify_added_to_circle(user,new_user)
    @user = user
    @new_user = new_user
    Rails.logger.info("---------informing #{new_user} that #{user} added them to their circle")
    mail(:to => new_user.email, :subject => "#{user} added you to their circle")
  end
end