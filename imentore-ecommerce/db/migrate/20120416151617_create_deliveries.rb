class CreateDeliveries < ActiveRecord::Migration
  def up
    create_table(:imentore_deliveries) do |t|
      t.integer :order_id
      t.text    :address
      t.string  :tracking_code
      t.string  :status
      t.integer :delivery_method_id
    end
  end

  def down
    drop_table(:imentore_deliveries)
  end
end
