class AddStoreIdToCart < ActiveRecord::Migration
  def change
    add_column :imentore_carts, :store_id, :integer
  end
end
