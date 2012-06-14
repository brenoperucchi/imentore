class AlterOrder < ActiveRecord::Migration
  def up
    add_column :imentore_orders, :customer_name, :string
  end

  def down
    remove_column :imentore_orders, :customer_name
  end
end
