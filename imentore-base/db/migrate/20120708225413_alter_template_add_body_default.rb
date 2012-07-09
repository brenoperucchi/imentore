class AlterTemplateAddBodyDefault < ActiveRecord::Migration
  def change
    add_column :imentore_templates, :body_default, :text
  end

end
