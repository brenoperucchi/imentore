class AddDeletedAtToProducts < ActiveRecord::Migration
  def change
    add_column :imentore_products, :deleted_at, :datetime
    add_index :imentore_products, :deleted_at
  end
end
