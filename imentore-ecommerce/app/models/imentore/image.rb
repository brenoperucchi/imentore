module Imentore
  class Image < ActiveRecord::Base

    belongs_to :imageable, polymorphic: true
    before_destroy :remove_file
    # has_many    :options, class_name: "::Imentore::OptionValue"
    # has_many    :images
    # belongs_to  :product

    mount_uploader :picture, PictureUploader

    def remove_file
      self.remove_picture!
    end

    # validates :price, :quantity, presence: true
  end
end