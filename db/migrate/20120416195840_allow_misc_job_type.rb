class AllowMiscJobType < ActiveRecord::Migration
  def change
    add_column(:job_types, :is_misc, :boolean, :default => false)
  end
end
