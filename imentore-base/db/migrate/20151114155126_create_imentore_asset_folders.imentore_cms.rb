# This migration comes from imentore_cms (originally 20151114081822)
class CreateImentoreAssetFolders < ActiveRecord::Migration
  def change
    create_table :imentore_asset_folders do |t|
      t.string :name
      t.references :asset
      t.references :user
      t.references :parent

      t.timestamps
    end
  end
end
