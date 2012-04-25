module Imentore
  class Product < ActiveRecord::Base
    has_many    :options,   class_name: "::Imentore::OptionType"
    has_many    :variants,  class_name: "::Imentore::ProductVariant"
    belongs_to  :store

    validates :name, :description, :store, presence: true

    accepts_nested_attributes_for :variants


    def all_images
      imgs = []
      variants.each do |variant|
        imgs = variant.images.collect {|image| image}
      end
      return imgs
    end

  end
end
