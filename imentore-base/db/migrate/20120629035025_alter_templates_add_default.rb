class AlterTemplatesAddDefault < ActiveRecord::Migration
  def change
    add_column :imentore_templates, :default, :boolean, default: false
  end
end
