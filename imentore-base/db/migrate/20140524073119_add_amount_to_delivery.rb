class AddAmountToDelivery < ActiveRecord::Migration
  def change
    add_column :imentore_deliveries, :amount, :float
  end
end
