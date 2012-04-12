class AddHostingToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :hosting, :boolean, default: :false
  end
end
