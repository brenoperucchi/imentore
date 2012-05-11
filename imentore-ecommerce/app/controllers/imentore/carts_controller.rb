module Imentore
  class CartsController < BaseController
    # require_dependency 'line_item'

    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    respond_to :json, only: [:create, :index, :destroy, :show]


    def show
      respond_to do |wants|
        wants.json do
            render json: Imentore::CartPresenter.new(current_cart).to_json
        end
        wants.html
      end
    end

    def destroy
      respond_to do |wants|
        wants.json do
          begin
            # i = params[:number_id].to_i
            items = current_cart.items
            # binding.pry
            items.each_with_index do |item, i|
              items.delete_at(i) if items[i].variant.id == params[:variant_id].to_i and items[i].quantity == params[:quantity].to_i
            end
            current_cart.items = items
            current_cart.save
            render json: Imentore::CartPresenter.new(current_cart).to_json
          rescue Exception => msg
            binding.pry
          end
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
            end
            render json: Imentore::CartPresenter.new(current_cart).to_json
          rescue ActiveRecord::RecordNotFound
            render json: Imentore::CartPresenter.new(current_cart).to_json
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
