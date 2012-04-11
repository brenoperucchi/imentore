module Imentore
  class LineItem
    extend Forwardable
    attr_accessor :product, :variant, :quantity

    def_delegators :@variant, :price, :deliverable?
    def_delegators :@product, :name

    def initialize(product, variant, quantity)
      @product, @variant, @quantity = product, variant, quantity
    end

    def quantity
      @quantity.to_i
    end
  end
end