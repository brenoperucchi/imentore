module Imentore
  class CheckoutsController < BaseController
    def new
      unless current_order
        order = current_store.orders.create
        session[:order_id] = order.id
      end

      @order = current_order
      @order.update_attribute(:items, current_cart.items)
    end

    def confirm
      @order = current_order
      CheckoutService.place_order(@order, params[:order])

      unless @order.chargeable?
        redirect_to complete_checkout_path
      end
    end

    def complete
    end

    protected

    def current_order
      @current_order ||= current_store.orders.find_by_id(session[:order_id])
    end
  end
end
