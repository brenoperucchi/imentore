class AlterProductVariant < ActiveRecord::Migration
  def up
    change_column :imentore_product_variants, :price, :decimal, :precision => 10, :scale => 2
    change_column :imentore_product_variants, :weight, :decimal, :precision => 10, :scale => 3
    change_column :imentore_product_variants, :height, :decimal, :precision => 10, :scale => 3
    change_column :imentore_product_variants, :width, :decimal, :precision => 10, :scale => 3
    change_column :imentore_product_variants, :depth, :decimal, :precision => 10, :scale => 3
  end

  def down
    change_column :imentore_product_variants, :weight, :integer
    change_column :imentore_product_variants, :height, :integer
    change_column :imentore_product_variants, :width, :integer
    change_column :imentore_product_variants, :depth, :integer
  end
end
