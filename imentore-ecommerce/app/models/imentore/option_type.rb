module Imentore
  class OptionType < ActiveRecord::Base
    validates :name, :handle, :product_id, presence: true
    validates :handle, uniqueness: { scope: "product_id" }
    validates :handle, format: { with: /[a-z]+[-a-z]+[a-z]+/ }

    def create_option_value(product)
      product.variants.each { |variant| variant.options.create(option_type: self, product_variant: variant, value:"") }
    end

    def destroy_option_value(product, option_type)
      product.variants.each { |variant| variant.options.where("option_type_id"=> option_type.id).delete_all }
    end
  end
end
