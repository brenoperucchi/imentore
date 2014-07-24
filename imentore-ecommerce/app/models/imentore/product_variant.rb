module Imentore
  class ProductVariant < ActiveRecord::Base
    has_many    :options, class_name: "::Imentore::OptionValue", dependent: :destroy
    has_many    :images, as: :imageable, dependent: :destroy 
    belongs_to  :product

    accepts_nested_attributes_for :options
    validates :price, :quantity, presence: true

    def options_name
      options.collect{|option| option.option_type.name + ":" + option.value}.join(' / ')
    end

    def update_stock(qtd)
      object = self.class.find_by_id(id)
      return true if object.nil?
      object.update_attribute(:quantity, (qtd + object.quantity))
    end

    def valid_stock?(quantity_need = 0)
      quantity_object = self.class.find_by_id(id).quantity 
      quantity_object >= quantity_need and quantity_object > 0
    end

    def value
      price = price_deal? ? price_deal : self.price
    end

    def price_deal
      read_attribute(:price_deal).nil? ? nil : read_attribute(:price_deal)
    end

    def price_deal?
      !price_deal.nil? and price_deal > 0
    end
  end
end
