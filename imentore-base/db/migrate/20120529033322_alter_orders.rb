class AlterOrders < ActiveRecord::Migration
  def up
    add_column :imentore_orders, :user_id, :integer
  end

  def down
    remove_column :imentore_orders, :user_id
  end
end

