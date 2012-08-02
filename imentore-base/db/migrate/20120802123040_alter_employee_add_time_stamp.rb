class AlterEmployeeAddTimeStamp < ActiveRecord::Migration
  change_table :imentore_employees do |t|
    t.timestamps
  end
end
