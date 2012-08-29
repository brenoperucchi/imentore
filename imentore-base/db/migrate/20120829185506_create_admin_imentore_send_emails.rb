class CreateAdminImentoreSendEmails < ActiveRecord::Migration
  def up
    create_table :admin_imentore_send_emails do |t|
      t.boolean :active
      t.string :name
      t.string :subject
      t.text :body
      t.references :user
      t.timestamps
    end
  end

  def down
    drop_table :admin_imentore_send_emails
  end
end
