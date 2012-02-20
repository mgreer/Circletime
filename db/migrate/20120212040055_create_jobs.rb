class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.text :description
      t.integer :stars
      t.text :location
      t.datetime :date

      t.timestamps
    end
  end
end
