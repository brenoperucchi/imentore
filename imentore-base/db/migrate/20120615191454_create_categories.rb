class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :imentore_categories, :force => true do |t|
      t.string :name, :handle
      t.references :store
      t.timestamps
    end
  end

  def self.down
    drop_table :imentore_categories
  end
end
