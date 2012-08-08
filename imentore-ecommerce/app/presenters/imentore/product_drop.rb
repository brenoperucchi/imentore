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
      product_handle_path(@product.handle)
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

    def image
      @product.variants.first.images.first.picture.url(:thumb)
    end

    def variant_id
      @product.variants.first.id
    end
  end
end