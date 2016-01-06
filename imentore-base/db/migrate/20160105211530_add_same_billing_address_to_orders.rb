class AddSameBillingAddressToOrders < ActiveRecord::Migration
  def change
    add_column :imentore_orders, :same_billing_address, :boolean, default: false
  end
end
