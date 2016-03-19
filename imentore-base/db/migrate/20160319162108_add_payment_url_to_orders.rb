class AddPaymentUrlToOrders < ActiveRecord::Migration
  def change
    add_column :imentore_orders, :payment_url, :string
  end
end
