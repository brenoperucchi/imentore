# This migration comes from imentore_ecommerce (originally 20120416145709)
class CreateDeliveryMethods < ActiveRecord::Migration
  def up
    create_table(:imentore_delivery_methods) do |t|
      t.string  :name
      t.integer :store_id
      t.string  :handle
      t.text    :options
    end
  end

  def down
    drop_table(:imentore_delivery_methods)
  end
end
