class CreateImentoreDomainMails < ActiveRecord::Migration
  def self.up
    create_table :imentore_domain_mails do |t|
      t.string :name
      t.integer :plesk_id
      t.references :url
      t.timestamps
    end
  end
  def self.down
    drop_table :imentore_domain_mails
  end
end
