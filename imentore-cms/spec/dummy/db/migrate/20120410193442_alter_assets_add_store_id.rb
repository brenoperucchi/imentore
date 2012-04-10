class AlterAssetsAddStoreId < ActiveRecord::Migration
  def up
    add_column(:imentore_assets, :store_id, :integer)
  end

  def down
    remove_column(:imentore_assets, :store_id)
  end

end
