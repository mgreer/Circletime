class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :stars
      t.text :location
      t.string :email

      t.timestamps
    end
  end
end
