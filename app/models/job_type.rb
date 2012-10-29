class JobType < ActiveRecord::Base
  has_many :jobs
  belongs_to :work_unit
  
  attr_accessible :stars

  def to_s
    name
  end

end
