class AlterOrders < ActiveRecord::Migration
  def up
    add_column :imentore_orders, :created_at, :datetime
    add_column :imentore_orders, :updated_at, :datetime
    add_column :imentore_orders, :user_id, :integer
  end

  def down
    remove_column :imentore_orders, :created_at
    remove_column :imentore_orders, :updated_at
    remove_column :imentore_orders, :user_id
  end
end

