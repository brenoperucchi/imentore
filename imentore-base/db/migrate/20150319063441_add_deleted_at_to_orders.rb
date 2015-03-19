class AddDeletedAtToOrders < ActiveRecord::Migration
  def change
    add_column :imentore_orders, :deleted_at, :datetime
    add_index :imentore_orders, :deleted_at
  end
end
