# This migration comes from imentore_ecommerce (originally 20120403115713)
class CreateOrders < ActiveRecord::Migration
  def up
    create_table(:imentore_orders) do |t|
      t.text    :shipping_address
      t.text    :billing_address
      t.decimal :total_amount
      t.string  :status
      t.string  :customer_email
      t.text    :items
      t.integer :invoice_id
      t.integer :delivery_id
      t.integer :store_id
    end
  end

  def down
    drop_table(:imentore_orders)
  end
end
