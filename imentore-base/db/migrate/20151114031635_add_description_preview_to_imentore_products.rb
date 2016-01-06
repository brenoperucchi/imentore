class AddDescriptionPreviewToImentoreProducts < ActiveRecord::Migration
  def change
    add_column :imentore_products, :description_preview, :string
  end
end
