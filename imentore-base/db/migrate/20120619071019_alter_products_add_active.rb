class AlterProductsAddActive < ActiveRecord::Migration
  def change
    add_column :imentore_products, :active, :boolean, default: false
  end
end
