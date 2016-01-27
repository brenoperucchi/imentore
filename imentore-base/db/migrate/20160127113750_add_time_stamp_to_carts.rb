class AddTimeStampToCarts < ActiveRecord::Migration
  def change
    change_table :imentore_carts do |t|
      t.timestamps
    end
  end
end
