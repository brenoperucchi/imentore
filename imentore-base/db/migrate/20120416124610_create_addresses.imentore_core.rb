# This migration comes from imentore_core (originally 20120210192304)
class CreateAddresses < ActiveRecord::Migration
  def up
    create_table(:imentore_addresses) do |t|
      t.string :name, :street, :complement, :city, :state, :country, :zip_code, :phone
      t.references :addressable, polymorphic: true
    end
  end

  def down
    drop_table :imentore_addresses
  end
end