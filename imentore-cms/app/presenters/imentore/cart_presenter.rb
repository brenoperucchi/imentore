module Imentore
  class CartPresenter
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(cart)
      @cart = cart
    end

    def to_json
      @cart.items.map do |item|
        product = item.product
        variant = item.variant

        {
          "name" => product.name,
          "url" => product_path(product),
          "qtd" => item.quantity,
          "value" => item.amount,
          "variant_id" => variant.id,
          "thumbnail_url" => variant.images.first.picture.url(:super_thumb)
        }
      end
    end
  end
end
