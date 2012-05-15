module UsersHelper

  #lookup up an on-site user from the facebook uid
  def find_user_from_facebook( uid )
    uid = "#{uid}"
    uid.slice!("uid")
    authentication = Authentication.find :all, :conditions => "provider = 'facebook' AND uid = '#{uid}' "
    if authentication.first
      authentication.first.user
    else
      return false
    end
  end
  
  def get_pronoun_from_user( fb_user )
    if fb_user.gender == "male"
      "him"
    else
      "her"
    end
  end
  
  def to_slug( text )
    text.downcase.gsub(/[^a-z1-9]+/, '-')
  end

end
