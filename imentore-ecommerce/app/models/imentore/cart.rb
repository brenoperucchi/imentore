module Imentore
  require_dependency "imentore/line_item"
  require_dependency "imentore/product"
  require_dependency "imentore/product_variant"
  require_dependency "imentore/coupon"

  class Cart < ActiveRecord::Base
    # attr_accessor :delivery_method, :zip_code, :html
    serialize :items, Array

    has_many :coupons_orders
    has_many :coupons, :through => :coupons_orders, :source => :coupon

    def empty?
      items.empty?
    end

    def valid_stock?
      items.each do |i| 
        unless i.variant.valid_stock?(i.quantity)
          errors.add(:base, I18n.t(:stock_null, scope: [:activerecord, :attributes, :errors, self.class.name.to_underscore]))
          return false
        end
      end
    end

    def renew(product, variant, quantity)
      items.delete_if do |i|
        i.product == product && i.variant == variant && quantity == 0
      end
      item = items.detect { |i| i.product == product && i.variant == variant }
      if item
        item.quantity = quantity
      end
      valid_stock? and save
    end

    def add(product, variant, quantity)
      return false if quantity < 0 
      item = items.detect { |i| i.product == product && i.variant == variant }
      if item
        item.quantity += quantity
        return false unless variant.valid_stock?(item.quantity) 
      else
        items << LineItem.new(product, variant, quantity)
        return false unless variant.valid_stock?(quantity) 
      end
      save
    end

    def coupons_amount
      coupons.to_a.sum(&:value)
    end

    def amount
      items.to_a.sum(&:amount)
    end

    def weight
      items.to_a.sum(&:weight)
    end

    def total_items
      items.to_a.sum(&:quantity)
    end

    # def delivery_amount
    #   return 0 if zip_code.nil? or delivery_method.nil?
    #   items.sum{|i| i.delivery_calculate(zip_code, delivery_method).value}
    # end

    def total_amount
      amount + coupons_amount 
    end

  end
end
