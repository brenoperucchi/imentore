class AddFolderIdToAssetFolders < ActiveRecord::Migration
  def change
    remove_column :imentore_asset_folders, :asset_id, :integer
  end
end
