class AddRelationToApplication < ActiveRecord::Migration
  def change
    change_table :applications do |t|
      t.references :user
      t.references :job
    end
  end
end
