class AlterThemesAddDefault < ActiveRecord::Migration
  def up
    add_column(:themes, :default, :boolean, default: false)
  end

  def down
    remove_column(:themes, :default)
  end
end