class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :set_timezone

  def set_timezone
    old_time_zone = Time.zone
    Time.zone = current_user.timezone unless current_user.blank?
    Rails.logger.info("*****ZONE: #{Time.zone}") 
    yield
  ensure
    Time.zone = old_time_zone
  end
end
