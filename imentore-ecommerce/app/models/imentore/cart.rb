module Imentore
  require_dependency "imentore/line_item"
  require_dependency "imentore/product"
  require_dependency "imentore/product_variant"

  class Cart < ActiveRecord::Base
    serialize :items, Array

    def empty?
      items.empty?
    end

    def add(product, variant, quantity)
      items << LineItem.new(product, variant, quantity)
      save
    end

    def amount
      items.sum(&:amount)
    end
  end
end
