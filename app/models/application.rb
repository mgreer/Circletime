class Application < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  def to_s
    @user + " " + @job + " on " + created
  end
end
