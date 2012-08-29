class AlterImentoreTemplates < ActiveRecord::Migration
  def up
    change_column :imentore_templates, :body_default, :text
    add_column :imentore_templates, :body_default_updated_at, :datetime
    add_column :imentore_templates, :admin_imentore_template_id, :integer
  end

  def down
    change_column :imentore_templates, :body_default, :string
    remove_column :imentore_templates, :body_default_updated_at
    remove_column :imentore_templates, :admin_imentore_template_id
  end
end
