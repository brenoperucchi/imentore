module Imentore
  class CheckoutsController < BaseController
    before_filter :authenticate_to_buy!, only: [:new, :confirm, :complete]
    before_filter :customer_only

    def customer_only
      redirect_to(root_path, alert: :admin_denied) if user_signed_in? and current_user.userable.owner?
    end

    def authenticate_to_buy!
      authenticate_user! if current_store.config.authenticate_to_buy == "1"
    end

    def new
      unless current_order
        order = current_store.orders.create
        session[:order_id] = order.id
      end
      @order = current_order

      if @order.deliverable?
        @order.build_delivery
      end
      @order.items = current_cart.items
      @order.save
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
