class RemoveDateField < ActiveRecord::Migration
  def change
    remove_column(:jobs, :date)
  end
end
