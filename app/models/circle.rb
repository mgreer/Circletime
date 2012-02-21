class Circle < ActiveRecord::Base
  belongs_to :user
  has_many :jobs
  has_many :memberships
  has_many :users, :through => :memberships
  
  def to_s
    user.name + "'s " + name + " circle"
  end
end
