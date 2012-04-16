# This migration comes from imentore_ecommerce (originally 20120319193757)
class AddPleskIdToDomainsTable < ActiveRecord::Migration
  def up
  	add_column(:imentore_domains, :plesk_id, :integer)
  end

  def down
  	remove_column(:imentore_domains, :plesk_id)
  end
end
