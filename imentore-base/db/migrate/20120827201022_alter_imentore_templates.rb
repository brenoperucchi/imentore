class AlterImentoreTemplates < ActiveRecord::Migration
  def up
    add_column :imentore_templates, :admin_imentore_template_id, :integer
  end

  def down
    remove_column :imentore_templates, :admin_imentore_template_id
  end
end