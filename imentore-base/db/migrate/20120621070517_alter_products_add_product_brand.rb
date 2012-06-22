class AlterProductsAddProductBrand < ActiveRecord::Migration
  def change
    add_column :imentore_products, :product_brand_id, :integer
  end
end
