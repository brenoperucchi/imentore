module Imentore
  class CartsController < BaseController

    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    respond_to :json, only: [:create, :index, :destroy, :show, :calculate_shipping]

    def calculate_shipping
      zip = params[:zip_code]
        method = current_store.delivery_methods.find_by_id(params[:method])
      unless method.nil?
        session[:delivery_method_id] = method.id
        respond_to do |wants|
          wants.json do
            render json: Imentore::DeliveryHandle.calculate_items(current_cart.items, zip, method).to_json
          end
        end
      else
        render nothing: true, status: 403
      end
    end

    def update
      params[:items].each do |item|
        quantity = item[1][:quantity].to_i
        return if quantity.blank?
        product = current_store.products.find_by_id(item[1][:product_id])
        variant = product.variants.find_by_id(item[1][:variant_id])
        current_cart.renew(product, variant, quantity)
      end
      redirect_to cart_path
    end

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
            items = current_cart.items
            items.each_with_index do |item, i|
              items.delete_at(i) if items[i].variant.id == params[:variant_id].to_i and items[i].quantity == params[:quantity].to_i
            end
            current_cart.items = items
            current_cart.save
            render json: Imentore::CartPresenter.new(current_cart).to_json
          rescue Exception => msg
            render nothing: true, status: 403
          end
        end
        wants.html do
          product = current_store.products.find_by_id(params[:product_id])
          variant = product.variants.find_by_id(params[:variant_id])
          current_cart.renew(product, variant, 0)
          redirect_to cart_path
        end
      end
    end

    def create
      if not params[:item][:variant_id].present?
        flash[:alert] = "Need to select an variant"
        redirect_to product_path(current_store.products.find(params[:item][:product_id]))
        return false
      end
      product = current_store.products.find(params[:item][:product_id])
      variant = product.variants.find(params[:item][:variant_id])
      quantity = params[:item][:quantity].to_i
      respond_to do |wants|
        wants.json do
          begin
            if quantity > 0
              current_cart.add(product, variant, quantity)
            end
            render json: Imentore::CartPresenter.new(current_cart).to_json
          rescue ActiveRecord::RecordNotFound
            render json: Imentore::CartPresenter.new(current_cart).to_json
          end
        end
        wants.html do
          if quantity > 0
            current_cart.add(product, variant, quantity)
          end
          redirect_to cart_path
        end
      end
    end
  end
end
