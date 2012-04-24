class AlterDeliveryMethodsAddCalculator < ActiveRecord::Migration
  def up
    add_column(:imentore_delivery_methods, :calculator, :string)
  end

  def down
    remove_column(:imentore_delivery_methods, :calculator)
  end
end
