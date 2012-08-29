class CreateProjects < ActiveRecord::Migration
  def up
    create_table(:imentore_projects) do |t|
      t.string :name
      t.string :description
      t.string :budget
      t.string :estimated_of
      t.string :duration_of
      t.string :state

      t.references :dealer
      t.timestamp
    end
  end

  def down
    drop_table(:imentore_projects)
  end
end
