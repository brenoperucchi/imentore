class AlterCustomersAddActive < ActiveRecord::Migration
  def change
    add_column :imentore_customers, :active, :boolean, default: true
  end
end
