# This migration comes from imentore_ecommerce (originally 20120412220743)
class AlterDomainsAddEmails < ActiveRecord::Migration
  def up
    add_column(:imentore_domains, :emails, :text)
  end

  def down
    remove_column(:imentore_domains, :emails)
  end
end
