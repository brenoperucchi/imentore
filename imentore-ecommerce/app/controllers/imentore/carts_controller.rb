module Imentore
  class CartsController < BaseController
    def show
    end

    def create
      product = current_store.products.find(params[:item][:product_id])
      variant = product.variants.find(params[:item][:variant_id])
      quantity = params[:item][:quantity].to_i

      if quantity > 0
        current_cart.add(product, variant, quantity)
        current_cart.save
      end

      redirect_to cart_path
    end
  end
end
