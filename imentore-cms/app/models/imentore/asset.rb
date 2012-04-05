module Imentore
  class Asset < ActiveRecord::Base
    belongs_to :theme
    mount_uploader :file, AvatarUploader
  end
end