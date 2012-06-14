class CreateSendEmails < ActiveRecord::Migration
  def up
    create_table :imentore_send_emails do |t|
      t.boolean :active
      t.string :name
      t.string :subject
      t.text :body
      t.references :store
      t.timestamps
    end
  end

  def down
    drop_table(:imentore_send_emails)
  end
end
