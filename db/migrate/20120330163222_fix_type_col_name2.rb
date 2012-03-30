class FixTypeColName2 < ActiveRecord::Migration
  def change
    remove_column :jobs, :jobtype_id    
    change_table :jobs do |t|
      t.references :job_type
    end
  end
end
