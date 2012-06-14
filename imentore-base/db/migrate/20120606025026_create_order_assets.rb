class CreateOrderAssets < ActiveRecord::Migration
  def up
    create_table(:imentore_order_assets) do |t|
      t.string :file
      t.references :assetable, :polymorphic => true
      t.references :store
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_order_assets)
  end
end
