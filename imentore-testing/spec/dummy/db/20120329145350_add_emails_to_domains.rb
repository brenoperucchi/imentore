class AddEmailsToDomains < ActiveRecord::Migration
  def up
    add_column :imentore_domains, :emails, :string
  end

  def down
    remove_column :imentore_domains, :emails
  end

end
