class CreateAdminAssets < ActiveRecord::Migration
  def up
    create_table(:admin_imentore_assets) do |t|
      t.string :file
      t.references :theme
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_assets)
  end
end