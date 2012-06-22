class AlterPaymentMethod < ActiveRecord::Migration
  def up
    add_column :imentore_payment_methods, :description, :text
  end

  def down
    remove_column :imentore_payment_methods, :description
  end
end
