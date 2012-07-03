class AlterTemplateAddType < ActiveRecord::Migration
  def change
    add_column :imentore_templates, :kind, :string
  end
end
