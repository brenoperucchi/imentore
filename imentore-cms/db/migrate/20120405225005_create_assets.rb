class CreateAssets < ActiveRecord::Migration
  def up
    create_table(:imentore_assets) do |t|
      t.string :file
      t.references :theme
      t.timestamps
    end
  end

  def down
    remove_table(:imentore_assets)
  end
end