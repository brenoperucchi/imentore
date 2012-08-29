class CreateProposes < ActiveRecord::Migration
  def up
    create_table(:imentore_proposes) do |t|
      t.string :value
      t.string :description
      t.string :payment_description
      t.string :availability
      t.string :state
      t.references :project
      t.timestamp
    end
  end

  def down
    drop_table(:imentore_talents)
  end
end
