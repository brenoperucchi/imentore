class AlterStoresAddConfig < ActiveRecord::Migration
  def up
    add_column(:imentore_stores, :config, :text)
  end

  def down
    remove_column(:imentore_stores, :config)
  end
end
