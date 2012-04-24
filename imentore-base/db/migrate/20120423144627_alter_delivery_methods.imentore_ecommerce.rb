# This migration comes from imentore_ecommerce (originally 20120423143625)
class AlterDeliveryMethods < ActiveRecord::Migration
  def up
    add_column(:imentore_delivery_methods, :active, :boolean, default: false)
  end

  def down
    remove_column(:imentore_delivery_methods, :active)
  end
end
