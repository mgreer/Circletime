class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :job_id
      t.integer :action_id

      t.timestamps
    end
  end
end
