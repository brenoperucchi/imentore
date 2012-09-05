class AlterCategoryTurnOnCache < ActiveRecord::Migration
  def up
    add_column :imentore_categories, :ancestry_depth, :integer, :default => 0
  end

  def down
    remove_column :imentore_categories, :ancestry_depth
  end
end
