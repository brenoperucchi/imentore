class AddContentTypeToAdminImentoreAssets < ActiveRecord::Migration
  def change
    add_column :admin_imentore_assets, :content_type, :string
  end
end
