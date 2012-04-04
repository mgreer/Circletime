class JobType < ActiveRecord::Base
  has_many :jobs
  belongs_to :work_unit

  def to_s
    name
  end

end
