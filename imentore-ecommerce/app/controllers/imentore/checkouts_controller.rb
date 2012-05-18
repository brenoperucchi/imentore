module Imentore
  class CheckoutsController < BaseController
    before_filter :authenticate_to_buy!, only: [:new, :confirm, :complete]
    before_filter :customer_only
    # before_filter :require_methods, only: [:confirm]

    # def require_methods
    #   if params[:order][:payment_method].blank? or params[:order][:delivery_method].blank?
    #     @order = current_order
    #     # @order.attributes=params[:order]
    #     @order.errors.add(:payment_method) if params[:order][:payment_method].blank?
    #     @order.errors.add(:delivery_method) if params[:order][:delivery_method].blank?
    #     render :new
    #   end
    # end

    def customer_only
      redirect_to(root_path, alert: :admin_denied) if user_signed_in? and current_user.userable.owner?
    end

    def authenticate_to_buy!
      authenticate_user! if current_store.config.authenticate_to_buy == "1"
    end

    def new
      @order = current_order
    end

    def confirm
      @order = current_order

      CheckoutService.place_order(@order, params, current_cart)

      if not @order.valid?
        render :new
      else @order.chargeable?
        redirect_to charge_checkout_path
      # when true and @order.chargeable?
      end
      # if @order.chargeable? and @order.valid?
      #   redirect_to charge_checkout_path
      # else
      #   redirect_to complete_checkout_path
      # end
    end

    def charge
      @invoice = current_order.invoice
      @invoice.prepare
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
      @current_order
    end
  end
end
