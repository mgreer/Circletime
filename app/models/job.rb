class Job < ActiveRecord::Base
  belongs_to :user
  has_many :applications
  belongs_to :circle
  belongs_to :job_type
    
  def to_s
    description
  end
   
end
