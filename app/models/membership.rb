class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :circle
  
  def to_s
    user.name + " is in " + circle.user.name
  end

end
