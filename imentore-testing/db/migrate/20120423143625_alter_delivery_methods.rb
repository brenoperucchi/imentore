class AlterDeliveryMethods < ActiveRecord::Migration
  def up
    add_column(:imentore_delivery_methods, :active, :boolean, default: false)
  end

  def down
    remove_column(:imentore_delivery_methods, :active)
  end
end
