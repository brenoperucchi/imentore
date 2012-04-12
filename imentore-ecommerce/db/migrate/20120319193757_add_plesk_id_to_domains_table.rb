class AddPleskIdToDomainsTable < ActiveRecord::Migration
  def up
  	add_column :domains, :plesk_id, :integer
  end

  def down
  	remove_column :domains, :plesk_id
  end
end
