class AddCircleToJobs < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.references :circle
    end
    remove_column :circles, :job_id
  end
end
