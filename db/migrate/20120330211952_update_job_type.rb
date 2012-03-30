class UpdateJobType < ActiveRecord::Migration
  def change
    remove_column :work_units, :minutes    
    change_table :work_units do |t|
      t.integer :hours
    end
  end
end
