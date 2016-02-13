require 'yaml'

module Imentore 
  module Manager
    class SendEmail < ActiveRecord::Base

      def self.table_name 
        "admin_imentore_send_emails"
      end
      scope :active, -> { where(active: true) }
      def self.install_store(store)
        conf = YAML.load_file(File.expand_path("#{Rails.root}/../imentore-manager/app/defaults/send_emails/configuration.yml")  )
        conf.keys.each do |key|
          store.send_emails.create(active: true, body: conf[key]["body"], subject: conf[key]["subject"], name: conf[key]["name"])
        end
        return true
      end  

    end
  end
end