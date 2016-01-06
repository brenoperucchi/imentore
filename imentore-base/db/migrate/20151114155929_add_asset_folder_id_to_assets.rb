class AddAssetFolderIdToAssets < ActiveRecord::Migration
  def change
    add_reference :imentore_assets, :folder, index: true
  end
end
