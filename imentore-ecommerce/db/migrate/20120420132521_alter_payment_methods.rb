class AlterPaymentMethods < ActiveRecord::Migration
  def up
    add_column(:imentore_payment_methods, :active, :boolean, default: false)
  end

  def down
    remove_column(:imentore_payment_methods, :active)
  end
end
