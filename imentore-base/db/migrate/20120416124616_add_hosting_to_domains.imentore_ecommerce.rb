# This migration comes from imentore_ecommerce (originally 20120309222106)
class AddHostingToDomains < ActiveRecord::Migration
  def up
    add_column(:imentore_domains, :hosting, :boolean, default: false)
  end

  def down
    remove_column(:imentore_domains, :hosting)
  end
end
