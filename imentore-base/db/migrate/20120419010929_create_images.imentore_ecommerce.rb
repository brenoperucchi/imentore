# This migration comes from imentore_ecommerce (originally 20120419005729)
class CreateImages < ActiveRecord::Migration
  def up
    create_table(:imentore_images) do |t|
      t.string :picture
      t.references :imageable, :polymorphic => true
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_images)
  end
end