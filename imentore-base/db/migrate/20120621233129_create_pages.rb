class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :imentore_pages, :force => true do |t|
      t.boolean :active
      t.string :name
      t.string :handle
      t.text :body, :html
      t.references :store
      t.timestamps
    end
  end

  def self.down
    drop_table :imentore_pages
  end
end