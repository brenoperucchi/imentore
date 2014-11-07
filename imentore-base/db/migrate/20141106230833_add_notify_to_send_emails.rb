class AddNotifyToSendEmails < ActiveRecord::Migration
  def change
    add_column :imentore_send_emails, :notify, :boolean, default: false
    add_column :admin_imentore_send_emails, :notify, :boolean, default: false
  end
end
