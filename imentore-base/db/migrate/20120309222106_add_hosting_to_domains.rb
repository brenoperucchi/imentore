class AddHostingToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :hosting, :bollean, default: :false
  end
end
