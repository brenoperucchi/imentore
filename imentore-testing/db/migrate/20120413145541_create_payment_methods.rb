class CreatePaymentMethods < ActiveRecord::Migration
  def up
    create_table(:imentore_payment_methods) do |t|
      t.string  :name
      t.string  :handle
      t.text    :options
      t.integer :store_id
    end
  end

  def down
    drop_table(:imentore_payment_methods)
  end
end
