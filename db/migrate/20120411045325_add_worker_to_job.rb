class AddWorkerToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :worker_id, :integer
  end
end
