module Imentore
  class Image < ActiveRecord::Base

    belongs_to :imageable, polymorphic: true
    # has_many    :options, class_name: "::Imentore::OptionValue"
    # has_many    :images
    # belongs_to  :product

    mount_uploader :picture, PictureUploader

    # validates :price, :quantity, presence: true
  end
end
