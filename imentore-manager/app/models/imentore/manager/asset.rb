module Imentore 
    module Manager
    class Asset < ActiveRecord::Base
      def self.table_name
        "admin_imentore_assets"
      end
      attr_accessor :filename
      
      belongs_to :theme, class_name: 'Imentore::Manager::Theme'      
      before_destroy :remove_file

      mount_uploader :file, AdminFileUploader

      def remove_file
        self.remove_file!
      end

    end
  end
end