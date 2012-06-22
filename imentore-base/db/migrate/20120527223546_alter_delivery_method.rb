class AlterDeliveryMethod < ActiveRecord::Migration
  def up
    add_column :imentore_delivery_methods, :description, :text
  end

  def down
    remove_column :imentore_delivery_methods, :description
  end
end
