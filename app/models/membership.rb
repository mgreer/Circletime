class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :circle
  has_many :jobs, :through => :user

  audited :associated_with => :user
    
  validates :user_id, :uniqueness => { :scope => :circle_id, :message => "Can only add the user to the circle once" }
  
  def to_s
    user.name + " is in " + circle.user.name
  end

end
