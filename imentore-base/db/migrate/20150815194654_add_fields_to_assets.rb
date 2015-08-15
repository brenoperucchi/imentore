class AddFieldsToAssets < ActiveRecord::Migration
  def change
    add_column :imentore_assets, :content_type, :string
  end
end
