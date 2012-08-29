class CreateAdminThemes < ActiveRecord::Migration
  def up
    create_table(:admin_imentore_themes) do |t|
      t.string :name
      t.references :user
      t.timestamps
    end
  end

  def down
    drop_table(:admin_imentore_themes)
  end
end
