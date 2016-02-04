class AlterProductVariants < ActiveRecord::Migration
  def up
    add_column :imentore_product_variants, :picture, :string
  end

  def down
    remove_column :imentore_product_variants, :picture
  end
end
