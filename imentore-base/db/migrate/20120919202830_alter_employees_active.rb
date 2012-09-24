class AlterEmployeesActive < ActiveRecord::Migration
  def change
    add_column :imentore_employees, :active, :boolean, default: true
  end
end
