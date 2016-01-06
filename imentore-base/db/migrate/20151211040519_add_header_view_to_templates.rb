class AddHeaderViewToTemplates < ActiveRecord::Migration
  def change
    add_column :imentore_templates, :header_view, :text
  end
end
