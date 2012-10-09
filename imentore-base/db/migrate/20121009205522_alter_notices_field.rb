class AlterNoticesField < ActiveRecord::Migration
  def up
    rename_column :imentore_notices, :description, :body
  end

  def down
    rename_column :imentore_notices, :body, :description
  end
end
