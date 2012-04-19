class CreateImages < ActiveRecord::Migration
  def up
    create_table(:imentore_images) do |t|
      t.string :picture
      t.references :imageable, :polymorphic => true
      t.timestamps
    end
  end

  def down
    remove_table(:imentore_images)
  end
end