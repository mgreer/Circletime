class SeperateDateAndTime < ActiveRecord::Migration
  def up
    remove_column :jobs, :date  
    add_column :jobs, :date, :date    
    add_column :jobs, :time, :time    
    add_column :jobs, :duration, :integer    

  end

  def down
  end
end
