class UserMailer < ActionMailer::Base
  default :from => "PoppyGo Notifications <notifications@poppygo.com>"
  
  def notify_added_to_circle(user,new_user)
    @user = user
    @new_user = new_user
    Rails.logger.info("---------informing #{new_user} that #{user} added them to their circle")
    mail(:to => new_user.email, :subject => "#{user} has added you on PoppyGo.").deliver
  end
  
  def notify_accepted_invitation(user,new_user)
    @user = user
    @new_user = new_user
    Rails.logger.info("---------informing #{user} that #{new_user} accepted their invitation")
    mail(:to => user.email, :subject => "#{new_user} has accepted your invitation.").deliver
  end
  
  def invitation_instructions( new_user )
    @resource = new_user
    Rails.logger.info("---------inviting #{@resource} to Circletime")
    mail(:to => @resource.email, :subject => "#{@resource.invited_by} wants you to join PoppyGo.").deliver
  end
end