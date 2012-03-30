class AddType < ActiveRecord::Migration
  def up  
    add_column :jobs, :type, :integer
  end

  def down
  end
end
