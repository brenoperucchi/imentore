# This migration comes from imentore_ecommerce (originally 20120321120103)
class CreateProductVariants < ActiveRecord::Migration
  def up
    create_table(:imentore_product_variants) do |t|
      t.decimal     :price
      t.integer     :quantity
      t.string      :sku
      t.decimal     :weight
      t.decimal     :height
      t.decimal     :width
      t.decimal     :depth
      t.boolean     :shippable
      t.references  :product
    end
  end

  def down
    drop_table(:imentore_product_variants)
  end
end
