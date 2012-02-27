class CreateThemes < ActiveRecord::Migration
  def up
    create_table(:themes) do |t|
      t.string :name
      t.references :store
    end
  end

  def down
    drop_table(:themes)
  end
end
