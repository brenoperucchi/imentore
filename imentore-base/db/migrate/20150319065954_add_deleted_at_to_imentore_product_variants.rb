class AddDeletedAtToImentoreProductVariants < ActiveRecord::Migration
  def change
    add_column :imentore_product_variants, :deleted_at, :datetime
    add_index :imentore_product_variants, :deleted_at
  end
end
