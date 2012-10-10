class AddOldStoreIdStores < ActiveRecord::Migration
  def up
    add_column :imentore_stores, :old_store_id, :integer
  end

  def down
    remove_column :imentore_stores, :old_store_id, :integer
  end
end
