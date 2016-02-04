class CreateOptionValues < ActiveRecord::Migration
  def up
    create_table(:imentore_option_values) do |t|
      t.references  :option_type
      t.references  :product_variant
      t.string      :value
    end
  end

  def down
    drop_table(:imentore_option_values)
  end
end
