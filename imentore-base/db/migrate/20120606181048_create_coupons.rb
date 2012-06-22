class CreateCoupons < ActiveRecord::Migration
  def up
    create_table(:imentore_coupons) do |t|
      t.boolean :active
      t.string :name
      t.string :code
      t.float :value
      t.references :store#, :cart, :order
      t.integer :limit_customer
      t.integer :limit_use
      t.datetime :due_at
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_coupons)
  end
end
