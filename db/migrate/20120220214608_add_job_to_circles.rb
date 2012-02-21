class AddJobToCircles < ActiveRecord::Migration
  def change
    change_table :circles do |t|
      t.references :job
    end
  end
end
