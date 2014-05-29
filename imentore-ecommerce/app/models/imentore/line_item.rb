module Imentore
  class LineItem
    extend Forwardable
    attr_accessor :product, :variant, :quantity, :store

    def_delegators :@variant, :price, :deliverable?
    def_delegators :@product, :name
    def_delegators :@variant, :weight
    def_delegators :@product, :store

    def initialize(product, variant, quantity)
      @product, @variant, @quantity = product, variant, quantity
    end

    def quantity
      @quantity.to_i
    end

    def amount
      quantity * variant.price
    end

    def deliverable?
      true
    end

    def delivery_calculate(zip_code, method)
      Imentore::DeliveryHandle.calculate_item(self, zip_code, method)
    end

    def variant_options
      variant.options.collect{|x| [x.option_type.name, x.value] }
    end

  end
end
