module Imentore
  class CheckoutsController < BaseController
    def new
      unless current_order
        order = current_store.orders.create
        session[:order_id] = order.id
      end

      @order = current_order

      if @order.deliverable?
        @order.build_delivery
      end

      # @order.update_attribute(:items, current_cart.items)
      # @order.update_attribute(:items, [Imentore::LineItem.new(1,1,1)])
      @order.items = current_cart.items.dup
    end

    def confirm
      @order = current_order
      CheckoutService.place_order(@order, params[:order])

      unless @order.chargeable?
        redirect_to(complete_checkout_path) and return
      end

      @invoice = @order.invoice
    end

    def complete
    end

    protected

    def current_order
      @current_order ||= current_store.orders.find_by_id(session[:order_id])
    end
  end
end
