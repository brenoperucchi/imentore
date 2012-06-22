class AddAncestryToImentoreCategories < ActiveRecord::Migration
  def change
    add_column :imentore_categories, :ancestry, :string
    add_index :imentore_categories, :ancestry
  end
end
