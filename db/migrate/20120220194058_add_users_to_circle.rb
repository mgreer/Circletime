class AddUsersToCircle < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.integer :members, :references => "user"
    end
  end
  
end
