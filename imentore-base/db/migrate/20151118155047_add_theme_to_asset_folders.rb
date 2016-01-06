class AddThemeToAssetFolders < ActiveRecord::Migration
  def change
    add_reference :imentore_asset_folders, :theme, index: true
  end
end
