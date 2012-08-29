class AlterAdminImentoreThemes < ActiveRecord::Migration
  def up
    add_column :admin_imentore_themes, :active, :boolean
    add_column :admin_imentore_themes, :used_for, :string 
  end

  def down
    remove_column :admin_imentore_themes, :active
    remove_column :admin_imentore_themes, :used_for
  end
end
