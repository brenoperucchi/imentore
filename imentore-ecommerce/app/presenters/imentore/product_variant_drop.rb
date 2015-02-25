module Imentore
  class ProductVariantDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @variant.send(method)
    end

    def initialize(variant)
      @variant = variant
    end

    def id
      @variant.id
    end

    def product
      @product = ProductDrop.new(@variant.product)
    end

    def price
      number_with_price(@variant.price)
    end

    def value
      number_with_price(@variant.value)
    end

    def options
      @variant.options.collect {|option| OptionValueDrop.new(option)}
    end

    def product_code
      @variant.sku
    end

  end
end