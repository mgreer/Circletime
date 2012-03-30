class FixTypeColName < ActiveRecord::Migration
  def change
    remove_column :jobs, :type    
    change_table :jobs do |t|
      t.references :jobtype
    end
  end
end
