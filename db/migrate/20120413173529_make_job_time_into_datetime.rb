class MakeJobTimeIntoDatetime < ActiveRecord::Migration
  def change
    remove_column(:jobs, :time)
    add_column(:jobs, :time, :datetime)
    execute 'alter table jobs alter column time set default now()'
  end
end
