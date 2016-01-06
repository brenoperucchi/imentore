class AlterFieldsToAssetFolders < ActiveRecord::Migration
  def change
    add_column :imentore_asset_folders, :ancestry, :string
    add_index :imentore_asset_folders, :ancestry
    add_column :imentore_asset_folders, :ancestry_depth, :integer, :default => 0
    remove_column :imentore_asset_folders, :parent_id, :integer
    add_column :imentore_asset_folders, :store_id, :integer
  end
end
