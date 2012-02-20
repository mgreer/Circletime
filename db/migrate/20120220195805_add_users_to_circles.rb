class AddUsersToCircles < ActiveRecord::Migration
  def change
      remove_column :jobs,:members
  end
end
