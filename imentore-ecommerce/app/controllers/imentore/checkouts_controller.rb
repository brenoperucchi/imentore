module Imentore
  class CheckoutsController < BaseController
    include PagamentoDigital::Helper
    before_action :authenticate_to_buy!, only: [:new, :confirm, :address]
    before_action :check_cart, only:[:address]
    skip_before_action :authorize_client, except: [:new]
    skip_before_action :verify_authenticity_token, :check_store, only: [:return_mp, :return_pd, :sync_pd, :return_pg, :sync_pg,
                                                                         :sync_mp, :complete]

    def check_cart
      if current_cart.total_amount == 0 or current_cart.items.size == 0
        redirect_to cart_path
        flash[:alert] = t(:cart_not_valid)
      elsif not current_cart.valid_stock?
        flash[:alert] = current_cart.errors.full_messages.first
        redirect_to cart_path
      end
    end

    def customer_only
      # redirect_to(cart_path, alert: :admin_denied) if user_signed_in? and current_user.userable.owner?
    end

    def authenticate_to_buy!
      authenticate_user! unless current_store.config.authenticate_to_buy
    end
      
    def new
      @order = current_order
      @image = @order.assets.new
    end

    def address
      @order = current_order
      @image = @order.assets.new
      if request.get?
        @order.shipping_address = current_user.userable.try(:addresses).try(:first).try(:dup) if user_signed_in?
        render :address
      elsif request.put?
        @order.shipping_checkbox = params[:order][:shipping_checkbox]
        @order.billing_checkbox = params[:order][:billing_checkbox]
        if user_signed_in? and not current_user.userable.owner?
          @order.customer_name = current_user.userable.name
          @order.customer_email = current_user.email
          @order.user = current_user
        else
          @order.customer_name = params[:order][:customer_name]
          @order.customer_email = params[:order][:customer_email]
        end
        CheckoutService.place_address(@order, order_params)  
        unless @order.save
          render :address
        else          
          set_order(@order)
          redirect_to confirm_checkout_path(@order)
        end
      end
    end

    def confirm
      @order = current_store.orders.find(params[:id])
      @order.items = current_cart.items unless @order.placed?
      if @order.placed? or @order.canceled?
        redirect_to complete_checkout_path(id: @order)
      elsif request.get?
        render :confirm
      elsif request.put?
        CheckoutService.place_order(@order, order_params)
        unless CheckoutService.place_coupons(@order, current_cart, current_store)
          flash[:alert] = t(:coupon_not_valid)
          render :confirm and return false
        end
        if not @order.deliverable? 
          flash[:alert] = @order.errors.full_messages.join
          redirect_to cart_path
        elsif @order.chargeable? and @order.save
          @order.place if charge?
        else
          flash[:alert] = @order.errors.full_messages.join(" / ")
          render :confirm
        end
      end
    end

    def charge?
      begin
        @order = current_store.orders.find(params[:id])
        @invoice = @order.invoice
        @prepare = @invoice.prepare
        send("#{@invoice.payment_method.handle}".to_underscore)
        set_order_cart_default
        return true
      rescue Exception => msg
        flash[:alert] = t(:checkout_charge_problem)
        render :confirm
      end
    end

    def custom
      complete
    end

    def mo_ip
      redirect_to @prepare['redirect_to'] if @prepare['redirect_to'].present?
    end

    def pagamento_digital
      pagamento_digital_form(@prepare)      
    end

    def pag_seguro
      redirect_to @prepare['redirect_to'] if @prepare['redirect_to'].present?
    end

    def payment_url(order)
      case order.invoice.payment_method.handle 
      when "pag_seguro", "mo_ip"
        invoice = order.invoice
        prepare = invoice.prepare
        prepare['redirect_to']
      end
    end

    def complete
      order = Imentore::Order.find_by_id(params[:id])
      order.payment_url = payment_url(order)
      @items = order.items.map {|item| CartItemDrop.new(item)}      
      render 'complete', locals: {order: OrderDrop.new(order)}
    end


    def sync_mp
      current_store = Imentore::Store.find(params[:store_id])
      invoice = current_store.invoices.find_by_id(params[:id_transacao])
      render nothing: true and return if invoice.nil?
      case params['status_pagamento']
      when "4", "1"
        invoice.confirm
      end
      render nothing: true
    end

    def sync_pg
      current_store = Imentore::Store.find(params[:store_id])
      notification_code = {notificationCode: params[:notificationCode]}
      provider_class = current_store.payment_methods.find_by_handle('pag_seguro').provider
      response = provider_class.notification_rpc(notification_code)
      invoice = current_store.invoices.find_by_id(response['transaction']['reference'])
      render nothing: true and return if invoice.nil? or not invoice.payment_method.pag_seguro?
      case response['transaction']['status']
      when '3','4'
        invoice.confirm
      end
      render nothing: true

    end

    def sync_pd
      invoice = Imentore::Invoice.find_by_id(params[:invoice_id])
      render nothing: true and return if invoice.nil? or not invoice.payment_method.pagamento_digital?
      notificacao = PagamentoDigital::Notificacao.new(params, invoice.payment_method.options['token'])
      invoice.confirm if notificacao.status == :concluida
      render nothing: true
    end

    def return_mp
      render nothing: true      
    end

    def return_pg
      invoice = Imentore::Invoice.find(params[:invoice_id])
      @order = invoice.order
      current_store = invoice.order.store
      redirect_to complete_checkout_url(host: current_store.url_site, id: @order.id)
    end

    def return_pd
      invoice = Imentore::Invoice.find(params[:invoice_id])
      @order = invoice.order
      current_store = invoice.order.store
      notificacao = PagamentoDigital::Notificacao.new(params, invoice.payment_method.options['token'])
      invoice.confirm if notificacao.status == :concluida
      redirect_to complete_checkout_url(host: current_store.url_site, id: @order.id)
    end

    protected

      def order_params
        params.require(:order).permit(:customer_name, :customer_email, :billing_checkbox, :shipping_checkbox, 
                                      shipping_address: [:name, :street, :complement, :city, :country, :state, :zip_code, :phone], 
                                      billing_address: [:name, :street, :complement, :city, :country, :state,:zip_code, :phone],
                                      delivery: [:delivery_method],
                                      invoice: [:payment_method])
      end

      def set_order_cart_default
        session[:order_id] = nil
        current_cart.destroy
      end

      def set_order(order)
        session[:order_id] = order.id
      end

      def current_order
        order = current_store.orders.find_by_id(session[:order_id])
        @current_order = if order.nil?
                          current_store.orders.new
                        else
                          order
                        end        
      end

  end
end