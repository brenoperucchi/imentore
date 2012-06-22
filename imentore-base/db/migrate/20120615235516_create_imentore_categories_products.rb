class CreateImentoreCategoriesProducts < ActiveRecord::Migration
  def self.up
    create_table :imentore_categories_products do |t|
      t.references :product, :category
    end
  end

  def self.down
    drop_table :imentore_categories_products
  end

end
