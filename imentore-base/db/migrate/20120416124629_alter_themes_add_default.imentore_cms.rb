# This migration comes from imentore_cms (originally 20120307114526)
class AlterThemesAddDefault < ActiveRecord::Migration
  def up
    add_column(:imentore_themes, :default, :boolean, default: false)
  end

  def down
    remove_column(:imentore_themes, :default)
  end
end