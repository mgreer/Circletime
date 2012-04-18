class AddEndToJob < ActiveRecord::Migration
  def change
    add_column(:jobs, :endtime, :datetime)      
  end
end
