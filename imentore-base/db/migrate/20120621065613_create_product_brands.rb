class CreateProductBrands < ActiveRecord::Migration
  def up
    create_table(:imentore_product_brands) do |t|
      t.string :name
      t.references :store
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_product_brands)
  end
end
