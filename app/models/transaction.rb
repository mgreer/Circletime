class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  CREATED = 0
  ACCEPTED = 1
  TURNEDDOWN = 2
  CANCELED = 3
  PAID = 4
  WAS_PAID = 5

  ACTIONS = {Transaction::CREATED => "created",Transaction::ACCEPTED => "accepted",
             Transaction::TURNEDDOWN => "turned down",Transaction::CANCELED => "canceled",
             Transaction::PAID => "paid for",Transaction::WAS_PAID => "was paid for"}
  
  def to_s
    "#{user} #{Transaction::ACTIONS[action_id]} #{job.user}'s favor"
  end
end
