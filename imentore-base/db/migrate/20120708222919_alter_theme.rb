class AlterTheme < ActiveRecord::Migration
  def up
    add_column :imentore_themes, :system, :boolean, default: false
  end

  def down
    remove_column :imentore_themes, :system
  end
end
