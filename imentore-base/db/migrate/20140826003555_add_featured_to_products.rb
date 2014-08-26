class AddFeaturedToProducts < ActiveRecord::Migration
  def change
    add_column :imentore_products, :featured, :boolean
  end
end
