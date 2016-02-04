module Imentore
  class Asset < ActiveRecord::Base
    def self.table_name
      "imentore_assets"
    end
    attr_accessor :filename

    mount_uploader :file, FileUploader

    belongs_to :folder, :class_name => Imentore::AssetFolder, :foreign_key => "folder_id"
    belongs_to :theme, :class_name => Imentore::Theme, :foreign_key => "theme_id"

    before_destroy :remove_file


    def remove_file
      self.remove_file!
    end

    # validates_uniqueness_of :file, :on => :create, :message => "must be unique", :if => proc { |obj| obj.class.find(:all, :conditions=> ['store_id == ?, and name == ?', obj.store_id, obj.file]).size >= 1 }
    # validates_uniqueness_of :attribute, :on => :create, :scope => [:store_id, :theme_id]
  end
end