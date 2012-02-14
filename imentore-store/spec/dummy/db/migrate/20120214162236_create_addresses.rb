class CreateAddresses < ActiveRecord::Migration
  def up
    create_table(:addresses) do |t|
      t.string :name, :street, :complement, :city, :state, :country, :zip_code, :phone
      t.references :addressable, polymorphic: true
    end
  end

  def down
    drop_table :addresses
  end
end
