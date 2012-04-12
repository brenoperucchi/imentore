# This migration comes from imentore_ecommerce (originally 20120302231906)
class CreateDomains < ActiveRecord::Migration
  def up
    create_table(:imentore_domains) do |t|
    	t.string :name
    	t.references :store
      t.timestamps
    end
  end

  def down
    remove_table(:imentore_domains)
  end
end