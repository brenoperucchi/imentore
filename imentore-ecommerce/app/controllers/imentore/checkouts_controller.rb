module Imentore
  class CheckoutsController < BaseController
    include PagamentoDigital::Helper
    before_filter :authenticate_to_buy!, only: [:new, :confirm]
    before_filter :check_cart, only:[:new]
    skip_before_filter :authorize_client, except: [:new]
    skip_before_filter :verify_authenticity_token, :check_store, only: [:return_mp, :return_pd, :sync_pd, :return_pg, :sync_pg,
                                                                         :sync_mp, :complete]

    def check_cart
      if current_cart.total_amount == 0 or current_cart.items.size == 0
        redirect_to cart_path
        flash[:alert] = t(:cart_not_valid)
      end
    end

    def customer_only
      # redirect_to(cart_path, alert: :admin_denied) if user_signed_in? and current_user.userable.owner?
      # binding.pry
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
        CheckoutService.place_order(@order, params)
          # if CheckoutService.place_order(@order, params)
          # flash[:alert] = @order.errors.full_messages
          # render :new and return false
          # end

        if user_signed_in? and not current_user.userable.owner?
          @order.customer_name = current_user.userable.name
          @order.customer_email = current_user.email
          @order.user_id = current_user
        else
          @order.customer_name = params[:order][:customer_name]
          @order.customer_email = params[:order][:customer_email]
        end
        if params[:order].present?
          # @order.billing_address = Imentore::Address.new(params[:order][:billing_address]) if params[:order][:billing_address].present?
          # @order.shipping_address = Imentore::Address.new(params[:order][:shipping_address]) if params[:order][:shipping_address].present?

          @order.billing_checkbox = params[:order][:billing_checkbox] if params[:order][:billing_checkbox]
          @order.shipping_checkbox = params[:order][:shipping_checkbox] if params[:order][:shipping_checkbox]
          unless CheckoutService.place_coupons(@order, current_cart, current_store)
            flash[:alert] = t(:coupon_not_valid)
            render :new and return false
          end
          if @order.save
            @order.place
          end
        end
        binding.pry
        if not @order.valid? and @order.deliverable? and @order.chargeable?
          render :new
          flash[:alert] = @order.errors.full_messages
        # unless 
          # render :new
        # elsif @order.chargeable? and @order.valid?
          # redirect_to charge_checkout_path
        else
          charge
          # binding.pry
          # render :new
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
        @prepare = @invoice.prepare
        send("#{@invoice.payment_method.name}".to_underscore)
      rescue Exception => msg
        flash[:alert] = t(:checkout_charge_problem)
        # @order = current_order
        render :new
      end
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

    def complete
      @current_order = Imentore::Order.find_by_id(params[:order_id])
      @items = @current_order.items.map { |item| CartItemDrop.new(item) }      
      @order = OrderDrop.new(@current_order)
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
      pagseguro = Imentore::Store.first.payment_methods.find_by_handle('pag_seguro')
      provider_class = "Imentore::PaymentMethod::PagSeguro".constantize.new(pagseguro.options)
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
      @current_order = invoice.order
      current_store = invoice.order.store
      redirect_to complete_checkout_url(host: current_store.url_site, order_id: @current_order.id)
    end

    def return_pd
      invoice = Imentore::Invoice.find(params[:invoice_id])
      @current_order = invoice.order
      current_store = invoice.order.store
      notificacao = PagamentoDigital::Notificacao.new(params, invoice.payment_method.options['token'])
      invoice.confirm if notificacao.status == :concluida
      # redirect_to complete_checkout_path
      redirect_to complete_checkout_url(host: current_store.url_site, order_id: @current_order.id)
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
