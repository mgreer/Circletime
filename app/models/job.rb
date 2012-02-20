class Job < ActiveRecord::Base
  has_one :application
  def to_s
    description
  end
   
end
