module Imentore
  class OrderAsset < ActiveRecord::Base

    belongs_to :assetable, polymorphic: true
    # has_many    :options, class_name: "::Imentore::OptionValue"
    # has_many    :images
    # belongs_to  :product

    mount_uploader :file, OrderAssetUploader

    # validates :price, :quantity, presence: true
  end
end
