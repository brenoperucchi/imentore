class AddHostingToDomains < ActiveRecord::Migration
  def up
    add_column(:imentore_domains, :hosting, :boolean, default: :false)
  end

  def down
    remove_column(:imentore_domains, :hosting)
  end
end
