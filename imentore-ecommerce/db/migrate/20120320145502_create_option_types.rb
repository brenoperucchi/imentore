class CreateOptionTypes < ActiveRecord::Migration
  def up
    create_table(:imentore_option_types) do |t|
      t.string      :name
      t.string      :handle
      t.references  :product
    end
  end

  def down
    drop_table(:imentore_option_types)
  end
end
