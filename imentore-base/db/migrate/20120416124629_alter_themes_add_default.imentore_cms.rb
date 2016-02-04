# This migration comes from imentore_cms (originally 20120307114526)
class AlterThemesAddDefault < ActiveRecord::Migration

  def up
    create_table :imentore_themes do |t|
      t.string :name
      t.references :store
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_themes)
  end
end