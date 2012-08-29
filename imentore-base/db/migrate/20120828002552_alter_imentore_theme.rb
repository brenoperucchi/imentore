class AlterImentoreTheme < ActiveRecord::Migration
  def up
    add_column :imentore_themes, :admin_imentore_theme_id, :integer
  end

  def down
    remove_column :imentore_themes, :admin_imentore_theme_id
  end
end
