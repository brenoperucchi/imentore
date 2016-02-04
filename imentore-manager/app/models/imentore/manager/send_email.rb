require 'yaml'

module Imentore 
  module Manager
    class SendEmail < ActiveRecord::Base

      def self.table_name 
        "admin_imentore_send_emails"
      end
      scope :active, -> { where(active: true) }
      def self.install_store(store)
        init = YAML.load_file(File.expand_path("#{Rails.root}/../imentore-manager/public/defaults/send_emails/initializer.yml")  )
        init.keys.each do |key|
          store.send_emails.create(active: true, body: init[key]["body"], subject: init[key]["subject"], name: init[key]["name"])
        end
        return true
      end  

    end
  end
end