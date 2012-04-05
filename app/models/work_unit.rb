class WorkUnit < ActiveRecord::Base
  has_many :job_types

  def to_s
    name
  end
end
