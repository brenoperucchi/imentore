class CreateNoticesTable < ActiveRecord::Migration
  def self.up
    create_table :imentore_notices, :force => true do |t|
      t.boolean :active
      t.string :name
      t.string :handle
      t.text :description
      t.references :store
      t.timestamps
    end
  end

  def self.down
    drop_table :imentore_notices
  end
end
