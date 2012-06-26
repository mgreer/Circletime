class Circle < ActiveRecord::Base
  belongs_to :user, :inverse_of => :circle
  has_many :jobs
  has_many :memberships
  has_many :users, :through => :memberships

  audited :associated_with => :user
  
  def to_s
    user.name + "'s circle"
  end
  
  before_save :default_values
  def default_values
    self.name = "Friends" unless self.name
  end
  
end
