class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.personhood
    end
  end

  def down
    drop_table :users
  end
end
