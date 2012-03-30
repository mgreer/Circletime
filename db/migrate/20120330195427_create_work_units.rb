class CreateWorkUnits < ActiveRecord::Migration
  def change
    create_table :work_units do |t|
      t.string :name
      t.integer :minutes
    end
    change_table :job_types do |t|
      t.references :work_unit
    end
  end
end
