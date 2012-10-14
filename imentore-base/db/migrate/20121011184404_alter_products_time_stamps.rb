class AlterProductsTimeStamps < ActiveRecord::Migration
  change_table :imentore_products do |t|
    t.timestamps
  end
end