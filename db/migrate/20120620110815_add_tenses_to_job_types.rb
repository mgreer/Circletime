class AddTensesToJobTypes < ActiveRecord::Migration
  def change
    add_column :job_types, :past, :string
    add_column :job_types, :future, :string
  end
end
