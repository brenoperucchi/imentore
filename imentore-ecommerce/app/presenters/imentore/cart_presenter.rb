module Imentore
  class CartPresenter
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(cart)
      @cart = cart
    end

    def to_json
      { 'success' => {  'empty' => (@cart.items.size == 0),
                        'items' =>
                                  @cart.items.dup.map do |item|
                                    product = item.product
                                    variant = item.variant
                                    {

                                      "name" => product.name,
                                      "url" => product_path(product),
                                      "quantity" => item.quantity,
                                      "value" => item.amount,
                                      "variant_id" => variant.id,
                                      "thumbnail_url" => variant.images.first.picture.url(:super_thumb)
                                    }
                                  end


                   },
        "total_items" =>  @cart.items.size,
        "total_amount" => @cart.amount,
        "message" => {
                       "success" => "Product Added",
                       "warning" => 'Product not found'
                     }
                 }
    end
  end
end
