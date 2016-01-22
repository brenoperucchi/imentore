module Imentore
  class CartsController < BaseController

    include SqlTemplate::ResolverMethods

    skip_before_action :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    respond_to :json, only: [:create, :index, :destroy, :show, :calculate_shipping]

    def calculate_shipping
      zip_code = params[:zip_code]
      delivery_method = current_store.delivery_methods.find_by_id(params[:method])
      unless delivery_method.nil?
        respond_to do |wants|
          wants.json do
            handle = Imentore::DeliveryHandle.new(current_cart.items, zip_code, current_store.config.store_zip_code, delivery_method)
            handle.calculate
            render json: { 'total_delivery' => number_with_price(handle.method.cost),
                           'total_coupon' => number_with_price(current_cart.coupons_amount),
                           'total_amount' => number_with_price(current_cart.total_amount +  handle.method.cost),
                           'delivery_time' => handle.method.delivery_time
                         }
          end
        end
      else
        render nothing: true, status: 403
      end
    end

    def update
      if params[:items].present?
        params[:items].each do |item|
          quantity = item[1][:quantity].to_i
          return if quantity.blank?
          product = current_store.products.find_by_id(item[1][:product_id])
          variant = product.variants.find_by_id(item[1][:variant_id])
          if current_cart.renew(product, variant, quantity)
            @notification = Imentore::ObjectDrop.new(Imentore::Notification.new(message: t(:cart_update), kind: 'success'))
            flash[:success] = t(:cart_update)
            flash[:alert] = nil
          else
            flash[:success] = nil
            flash[:alert] = current_cart.errors.full_messages.first
          end
        end
      end
      @content_for_footer = render_to_controller("imentore/carts/show", :header_view)
      render :show
    end

    def show
      @content_for_footer = render_to_controller("imentore/products/show", :header_view)
      respond_to do |wants|
        wants.json { render json: Imentore::CartPresenter.new(current_cart).to_json }
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
          redirect_to :back
        end
      end
    end

    def create
      if not params[:item][:variant_id].present?
        flash[:alert] = t(:cart_need_variant)
        redirect_to product_path(current_store.products.find(params[:item][:product_id]))
        return false
      end
      product = current_store.products.find(params[:item][:product_id])
      variant = product.variants.find(params[:item][:variant_id])
      quantity = params[:item][:quantity].to_i

      respond_to do |wants|
        set_current_cart
        wants.json do
          begin
            if quantity == 0 
              render :json => { "message" => {"alert" => I18n.t(:quantity_invalid, scope: 'helpers.cart.create') }}, status: 400
            elsif current_cart.add(product, variant, quantity)
              render json: Imentore::CartPresenter.new(current_cart).to_json
            else
              render :json => { "message" => {"alert" => I18n.t(:without_stock, scope: 'helpers.cart.create') }}, status: 400
            end
          rescue ActiveRecord::RecordNotFound
            render :json => { "message" => {"alert" => I18n.t(:not_valid, scope: 'helpers.cart.create') }}, status: 422
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

    protected

    def set_current_cart
      cart = current_cart
      if current_cart.id.nil?
        cart = current_store.carts.new
        cart.save(validate: false)
        session[:cart_id] = cart.id
      end
    end

  end
end
