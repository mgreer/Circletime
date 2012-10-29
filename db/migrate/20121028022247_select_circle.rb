class SelectCircle < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.references :job
      t.references :user

      t.timestamps
    end
  end
end
