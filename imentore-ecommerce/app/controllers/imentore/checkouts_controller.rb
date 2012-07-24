module Imentore
  class CheckoutsController < BaseController
    include PagamentoDigital::Helper
    before_filter :authenticate_to_buy!, only: [:new, :confirm, :complete]

    def customer_only
      redirect_to(cart_path, alert: :admin_denied) if user_signed_in? and current_user.userable.owner?
    end

    def authenticate_to_buy!
      authenticate_user! unless current_store.config.authenticate_to_buy
    end

    def new
      @order = current_order
      @image = @order.assets.new
    end

    def confirm
      @order = current_order
      if request.get?
        render :new
      elsif request.put?
        @order.items = current_cart.items
        unless CheckoutService.place_coupons(@order, current_cart, current_store)
          flash[:alert] = t(:coupon_not_valid)
          render :new and return false
        end
        CheckoutService.place_order(@order, params)

        if user_signed_in? and not current_user.userable.owner?
          @order.customer_name = current_user.userable.name
          @order.customer_email = current_user.email
          @order.user_id = current_user
        else
          @order.customer_name = params[:order][:customer_name]
          @order.customer_email = params[:order][:customer_email]
        end
        if params[:order].present?

          @order.billing_address = Imentore::Address.new(params[:order][:billing_address]) if params[:order][:billing_address].present?
          @order.shipping_address = Imentore::Address.new(params[:order][:shipping_address]) if params[:order][:shipping_address].present?

          @order.billing_checkbox = params[:order][:billing_checkbox] if params[:order][:billing_checkbox]
          @order.shipping_checkbox = params[:order][:shipping_checkbox] if params[:order][:shipping_checkbox]
          if @order.save
            @order.place
          end
        end
        if not @order.valid?
          render :new
        elsif @order.chargeable? and @order.valid?
          redirect_to charge_checkout_path
        else
          render :new
        end
      end
      # if @order.chargeable? and @order.valid?
      #   redirect_to charge_checkout_path
      # else
      #   redirect_to complete_checkout_path
      # end
    end

    def charge
      begin
        @order = current_order
        @invoice = current_order.invoice
        if @invoice.payment_method.name == "pagamento_digital"
          response = @invoice.prepare
          pagamento_digital_form(response)
        else
          response = @invoice.prepare
          redirect_to response['redirect_to'] if response['redirect_to'].present?
          render 'charge' if response['render']
        end
      rescue Exception => msg
        flash[:alert] =  "Information wrongs"
        @order = current_order
        render :new
      end
    end

    def complete
    end

    protected

    def current_order
      @current_order = current_store.orders.find_by_id(session[:order_id])
      unless @current_order
        @current_order = current_store.orders.create(false)
        session[:order_id] = @current_order.id
      end
      @current_order
    end
  end
end
