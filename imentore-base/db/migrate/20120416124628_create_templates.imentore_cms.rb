# This migration comes from imentore_cms (originally 20120229183726)
class CreateTemplates < ActiveRecord::Migration
  def up
    create_table(:imentore_templates) do |t|
      t.string  :path
      t.text    :body
      t.boolean :partial, default: false
      t.string  :layout
      t.string  :format, default: 'text/html'
      t.string  :locale, default: 'en'
      t.string  :handler, default: 'liquid'
      t.references :theme, :layout
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_templates)
  end
end
