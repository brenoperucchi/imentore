class AlterProductVariant < ActiveRecord::Migration
  def up
    change_column :imentore_product_variants, :price, :float, :lenght => :null
    change_column :imentore_product_variants, :weight, :float, :lenght => :null
    change_column :imentore_product_variants, :height, :float, :lenght => :null
    change_column :imentore_product_variants, :width, :float, :lenght => :null
    change_column :imentore_product_variants, :depth, :float, :lenght => :null
  end

  def down
    change_column :imentore_product_variants, :weight, :integer
    change_column :imentore_product_variants, :height, :integer
    change_column :imentore_product_variants, :width, :integer
    change_column :imentore_product_variants, :depth, :integer
  end
end
