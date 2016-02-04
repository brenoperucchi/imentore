class AlterThemesAddActive < ActiveRecord::Migration
  def change
    add_column :imentore_themes, :active, :boolean, default: false
  end
end