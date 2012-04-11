# This migration comes from imentore_ecommerce (originally 20120320142927)
class CreateProducts < ActiveRecord::Migration
  def up
    create_table(:imentore_products) do |t|
      t.string      :name
      t.text        :description
      t.string      :permalink
      t.references  :store
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_products)
  end
end
