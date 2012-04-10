# This migration comes from imentore_cms (originally 20120410193442)
class AlterAssetsAddStoreId < ActiveRecord::Migration
  def up
    add_column(:imentore_assets, :store_id, :integer)
  end

  def down
    remove_column(:imentore_assets, :store_id)
  end

end
