class Job < ActiveRecord::Base
  belongs_to :user
  has_many :applications
  belongs_to :circle
  belongs_to :job_type

  def work_unit
    job_type.work_unit
  end
    
  def to_s
    description
  end
   
end
