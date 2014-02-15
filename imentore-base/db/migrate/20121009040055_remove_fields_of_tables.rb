class RemoveFieldsOfTables < ActiveRecord::Migration
  def up
    remove_column :imentore_stores, :active, :boolean
  end

  def down
    add_column :imentore_stores, :active, :boolean, :default => false
  end
end