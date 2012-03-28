class CreateCarts < ActiveRecord::Migration
  def up
    create_table(:imentore_carts) do |t|
      t.integer :session_id
      t.text    :items
    end
  end

  def down
    drop_table(:imentore_carts)
  end
end
