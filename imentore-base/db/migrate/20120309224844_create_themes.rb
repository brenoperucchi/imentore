class CreateThemes < ActiveRecord::Migration
  def up
    create_table(:imentore_themes) do |t|
      t.string :name
      t.references :store
    end
  end

  def down
    drop_table(:imentore_themes)
  end
end
