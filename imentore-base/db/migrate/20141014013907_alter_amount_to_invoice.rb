class AlterAmountToInvoice < ActiveRecord::Migration
  def up
    change_column :imentore_deliveries, :amount, :decimal, :precision => 10, :scale => 2
  end

  def down
    change_column :imentore_deliveries, :amount, :integer
  end
end
