class JobType < ActiveRecord::Base
  has_many :jobs
  belongs_to :work_unit
  
  attr_accessible :stars, :name, :past, :future, :work_unit, :is_misc

  def to_s
    name
  end

end
