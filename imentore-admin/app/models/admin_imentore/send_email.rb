module AdminImentore
  class SendEmail < ActiveRecord::Base

    def self.table_name 
      "admin_imentore_send_emails"
    end
    scope :active, -> { where(active: true) }

    def self.install_store(store)
      self.active.each do |send_email|
        att = send_email.dup.attributes
        att.delete('user_id')
        store.send_emails.create(att)
      end
    end
    
  end
end