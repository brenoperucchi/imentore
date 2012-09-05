module Imentore
  class Asset < ActiveRecord::Base
    belongs_to :theme
    def self.table_name
      "imentore_assets"
    end

    attr_accessor :filename
    # validates_uniqueness_of :file, :on => :create, :message => "must be unique", :if => proc { |obj| obj.class.find(:all, :conditions=> ['store_id == ?, and name == ?', obj.store_id, obj.file]).size >= 1 }
    mount_uploader :file, FileUploader
    # validates_uniqueness_of :attribute, :on => :create, :scope => [:store_id, :theme_id]
  end
end