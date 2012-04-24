module Imentore
  class Cart < ActiveRecord::Base
    serialize :items, Array

    def empty?
      items.empty?
    end

    def add(product, variant, quantity)
      items << LineItem.new(product, variant, quantity)
    end
  end
end
