class CreateCustomers < ActiveRecord::Migration
  def up
    create_table :imentore_customers do |t|
      t.personhood
      t.references :store
      t.string :department
      t.timestamps
    end
  end

  def down
    drop_table :imentore_customers
  end
end
