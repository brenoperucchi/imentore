class CreateEmployees < ActiveRecord::Migration
  def up
    create_table :imentore_employees do |t|
      t.personhood
      t.references :store
      t.string :department
      t.timestamps
    end
  end

  def down
    drop_table :imentore_employees
  end
end
