# This migration comes from imentore_cms (originally 20120409221238)
class AddHeaderToTemplate < ActiveRecord::Migration
  def up
    add_column(:imentore_templates, :head, :text)
  end

  def down
    remove_column(:imentore_themes, :head)
  end
end
