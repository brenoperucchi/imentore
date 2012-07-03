module Imentore
  class ProductVariantDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    # def before_method(method)
    #   binding.pry
    #  end

    def initialize(variant)
      # binding.pry
      @variant = variant
    end

    def id
      @variant.id
    end

    # def url
    #   product_path(@product)
    #   # binding.pry
    # end

    def price
      @variant.price
    end

    def options
      @options = @variant.options
    end

    def product_code
      @variant.sku
    end

  end
end