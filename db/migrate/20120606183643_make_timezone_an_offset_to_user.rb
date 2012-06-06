class MakeTimezoneAnOffsetToUser < ActiveRecord::Migration
  def change
    remove_column :users, :time_zone
    add_column :users, :timezone_offset, :integer, :default => -8
  end
end
