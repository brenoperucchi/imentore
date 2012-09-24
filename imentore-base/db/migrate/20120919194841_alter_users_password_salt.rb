class AlterUsersPasswordSalt < ActiveRecord::Migration
  def change 
    add_column :imentore_users, :password_salt, :string
  end
end
