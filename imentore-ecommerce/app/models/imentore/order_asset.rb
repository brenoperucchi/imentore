module Imentore
  class OrderAsset < ActiveRecord::Base

    belongs_to :assetable, polymorphic: true
    before_destroy :remove_file
    # has_many    :options, class_name: "::Imentore::OptionValue"
    # has_many    :images
    # belongs_to  :product

    mount_uploader :file, OrderAssetUploader

    def remove_file
      self.remove_file!
    end

    # validates :price, :quantity, presence: true
  end
end
