module Imentore
  class ProductDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(product)
      @product = product
    end

    def name
      @product.name
    end

    def id
      @product.id
    end

    def url
      product_path(@product)
    end

    def price
      @product.variants.first.price
    end

    def product_code
      "XYZ"
    end

    def description
      @product.description
    end

    def variants
      @product.variants
    end
  end
end