module Imentore
  class CheckoutsController < BaseController
    def new
      @order = current_order
    end

    def confirm
      @order = current_order

      CheckoutService.place_order(@order, params[:order])

      if @order.chargeable?
        redirect_to charge_checkout_path
      else
        redirect_to complete_checkout_path
      end
    end

    def charge
      @invoice = current_order.invoice
    end

    def complete
    end

    protected

    def current_order
      @current_order ||= current_store.orders.find_by_id(session[:order_id])

      unless @current_order
        @current_order = current_store.orders.create
        session[:order_id] = @current_order.id
      end

      @current_order.items = current_cart.items.dup
      @current_order.save

      @current_order
    end
  end
end
