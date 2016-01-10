module Imentore
  class Product < ActiveRecord::Base
    acts_as_paranoid

    before_destroy :destroy_disabled

    attr_accessor :product_brand_name

    has_many    :options,   class_name: "::Imentore::OptionType", dependent: :destroy
    has_many    :variants,  class_name: "::Imentore::ProductVariant", dependent: :destroy
    belongs_to  :store
    belongs_to  :product_brand

    has_many :categories_products, dependent: :destroy
    has_many :categories, :through => :categories_products, :source => :category
    has_many :feedbacks, as: :feedbackable, dependent: :destroy

    scope :active,         -> { where(active: true) }
    scope :featured,       -> { where(featured: true) }
    scope :product_search, -> (object){ where("name like ?", "%#{object}%") }

    validates :name, :handle, :store, presence: true
    validates :handle, uniqueness: { scope: :store_id }
    # validates :handle, format: { with: /^[-A-Za-z\d_]+$/ }

    accepts_nested_attributes_for :variants, allow_destroy: true

    def destroy_disabled
      update_column(:active, 0)
    end

    def handle
      return if read_attribute(:name).blank?
      if read_attribute(:handle).blank? 
        self.handle = name.to_underscore
        read_attribute(:handle)
      else 
        read_attribute(:handle)
      end
    end

    def handle=(param)
      write_attribute(:handle, param.to_underscore!)
    end


    def all_images
      imgs = []
      variants.each do |variant|
        imgs << variant.images.map {|image| image}
      end
      imgs.reject{|x| x.blank?}.flatten
    end

    def stock_available?
      variants.each do |v| 
        return true if v.quantity > 0 
      end
      return false
    end

  end
end