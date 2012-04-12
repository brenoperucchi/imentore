# This migration comes from imentore_ecommerce (originally 20120411133231)
class CreateInvoices < ActiveRecord::Migration
  def up
    create_table(:imentore_invoices) do |t|
      t.integer :order_id
      t.string  :provider_id
      t.integer :payment_method_id
      t.string  :status
      t.decimal :amount
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_invoices)
  end
end
