module Imentore
  class Product < ActiveRecord::Base

    attr_accessor :product_brand_name

    has_many    :options,   class_name: "::Imentore::OptionType"
    has_many    :variants,  class_name: "::Imentore::ProductVariant"
    belongs_to  :store
    belongs_to  :product_brand

    has_many :categories_products
    has_many :categories, :through => :categories_products, :source => :category

    scope :active, where(active: true)

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
