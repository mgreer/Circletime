module UsersHelper

  def find_user_from_facebook( uid )
    uid = "#{uid}"
    uid.slice!("uid")
    Rails.logger.info("-------uid #{uid}")
    authentication = Authentication.find :all, :conditions => "provider = 'facebook' AND uid = '#{uid}' "
    Rails.logger.info("-------Authentication #{authentication}")
    if authentication.first
      authentication.first.user
    else
      return false
    end
  end

end
