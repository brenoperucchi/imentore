class AddPleskIdToDomainsTable < ActiveRecord::Migration
  def up
  	add_column(:imentore_domains, :plesk_id, :integer)
  end

  def down
  	remove_column(:imentore_domains, :plesk_id)
  end
end
