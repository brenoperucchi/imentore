class CreateAdminImentoreTemplates < ActiveRecord::Migration
  def up
    create_table :admin_imentore_templates do |t|
      t.string :layout
      t.string :path, :kind
      t.text :body
      t.references :user, :theme
      t.timestamps
    end
  end

  def down
    drop_table :admin_imentore_templates
  end
end
