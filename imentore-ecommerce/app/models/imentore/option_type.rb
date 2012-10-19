module Imentore
  class OptionType < ActiveRecord::Base
    validates :name, :product_id, presence: true
    validates :handle, uniqueness: { scope: "product_id" }
    # validates :handle, format: { with: /^[-A-Za-z\d_]+$/ }

    def create_option_types(product)
      product.variants.each { |variant| variant.options.create(option_type: self, product_variant: variant, value:"") }
    end

    def destroy_option_types(product, option_type)
      product.variants.each { |variant| variant.options.where("option_type_id"=> option_type.id).delete_all }
    end

    def handle
      return if read_attribute(:name).nil?
      read_attribute(:handle).nil? ? write_attribute(:handle, name.to_underscore) : read_attribute(:handle)
    end
    
  end
end
