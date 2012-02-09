class AlterStoresAddConfig < ActiveRecord::Migration
  def up
    add_column(:stores, :config, :text)
  end

  def down
    remove_column(:stores, :config)
  end
end
