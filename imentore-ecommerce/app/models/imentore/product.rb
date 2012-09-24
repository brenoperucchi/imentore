module Imentore
  class Product < ActiveRecord::Base

    attr_accessor :product_brand_name

    has_many    :options,   class_name: "::Imentore::OptionType", dependent: :destroy
    has_many    :variants,  class_name: "::Imentore::ProductVariant", dependent: :destroy
    belongs_to  :store
    belongs_to  :product_brand

    has_many :categories_products, dependent: :destroy
    has_many :categories, :through => :categories_products, :source => :category
    has_many :feedbacks, as: :feedbackable, dependent: :destroy

    scope :active, where(active: true)
    scope :product_search, lambda { |search| { :conditions => ["name like ?", "%#{search}%"] } }

    validates :name, :handle, :store, presence: true
    validates :handle, uniqueness: { scope: "id" }
    validates :handle, format: { with: /[a-z]+[-a-z]+[a-z]+/ }

    accepts_nested_attributes_for :variants

    def handle
      return if read_attribute(:name).nil?
      if read_attribute(:handle).nil? 
        update_attribute(:handle, name.to_underscore)
        self.handle 
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
