# This migration comes from imentore_cms (originally 20120405225005)
class CreateAssets < ActiveRecord::Migration
  def up
    create_table(:imentore_assets) do |t|
      t.string :file
      t.references :theme
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_assets)
  end
end