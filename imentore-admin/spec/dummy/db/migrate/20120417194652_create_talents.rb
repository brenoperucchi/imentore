class CreateTalents < ActiveRecord::Migration
  def up
    create_table(:imentore_talents) do |t|
      t.string :name
      t.string :kind
      t.string :experience
      t.string :resume
      t.string :description

      t.references :dealer
      t.timestamp
    end
  end

  def down
    drop_table(:imentore_talents)
  end
end
