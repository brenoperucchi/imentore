module Imentore
  class CartsController < BaseController
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    respond_to :json, only: [:create, :index, :destroy, :show]


    def show
      respond_to do |wants|
        wants.json do
            cart_json = CartPresenter.new(current_cart).to_json
            # cart_items = [[1,1,1],[1,1,2],[2,2,1],[2,2,2]]
            # json = cart_items.map { |cart| CartPresenter.new(cart, current_store).to_json }
            render json: { "success" => cart_json }
        end
        wants.html
      end
    end

    def destroy
      respond_to do |wants|
        wants.json do
          render status:200, json:{ "success" => "success"}
        end
      end
    end

    def create
      respond_to do |wants|
          wants.json do
          begin
            product = current_store.products.find(params[:product_id])
            variant = product.variants.find(params[:variant_id])
            quantity = params[:quantity].to_i
            if quantity > 0
              current_cart.add(product, variant, quantity)
              # binding.pry
            end
            render json: { "success" => "Product Added" }
          rescue ActiveRecord::RecordNotFound
            render json: { "error" =>
                            {
                              "warning" => 'Product not found'
                            }
                          }
          end
        end
        wants.html do
          product = current_store.products.find(params[:item][:product_id])
          variant = product.variants.find(params[:item][:variant_id])
          quantity = params[:item][:quantity].to_i

          if quantity > 0
            current_cart.add(product, variant, quantity)
          end

          redirect_to cart_path
        end
      end
    end
  end
end
