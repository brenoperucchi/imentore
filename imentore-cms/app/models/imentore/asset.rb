module Imentore
  class Asset < ActiveRecord::Base
    belongs_to :theme
    mount_uploader :file, FileUploader
  end
end