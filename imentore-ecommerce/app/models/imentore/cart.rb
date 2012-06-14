module Imentore
  require_dependency "imentore/line_item"
  require_dependency "imentore/product"
  require_dependency "imentore/product_variant"
  require_dependency "imentore/coupon"

  class Cart < ActiveRecord::Base
    attr_accessor :delivery_method
    serialize :items, Array

    has_many :coupons_orders
    has_many :coupons, :through => :coupons_orders, :source => :coupon

    def empty?
      items.empty?
    end

    def renew(product, variant, quantity)
      items.delete_if do |i|
        i.product == product && i.variant == variant && quantity == 0
      end
      item = items.detect { |i| i.product == product && i.variant == variant }
      if item
        item.quantity = quantity
      end
      save
    end

    def add(product, variant, quantity)
      item = items.detect { |i| i.product == product && i.variant == variant }
      if item
        item.quantity += quantity
      else
        items << LineItem.new(product, variant, quantity)
      end
      save
    end

    def coupons_amount
      coupons.sum(&:value)
    end

    def amount
      items.sum(&:amount)
    end

    def weight
      items.sum(&:weight)
    end

  end
end
