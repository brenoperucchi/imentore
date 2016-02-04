class CreateDomains < ActiveRecord::Migration
  def up
    create_table :imentore_domains do |t|
    	t.string :name
    	t.references :store
      t.timestamps
    end
  end

  def down
    drop_table :imentore_domains
  end
end
