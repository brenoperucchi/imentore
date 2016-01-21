module Imentore
  class CheckoutsController < BaseController
    include PagamentoDigital::Helper

    before_action :authenticate_to_buy!, only: [:confirm]
    before_action :check_order, only: [:address, :shipping, :payment]
    before_action :verify_cart_valid?, only:[:start]

    skip_before_action :authorize_client, except: [:new]
    skip_before_action :verify_authenticity_token, :check_store, only: [:return_mp, :return_pd, :sync_pd, :return_pg, :sync_pg,
                                                                         :sync_mp, :complete]
    def verify_cart_valid?
      return true unless request.get?
      if current_cart.nil?
        flash[:alert] = t(:cart_empty)
        redirect_to cart_path
        return false
      elsif current_cart.items.size == 0
        flash[:alert] = t(:cart_not_valid)
        redirect_to cart_path
        return false
      elsif not current_cart.valid_stock?
        flash[:alert] = current_cart.errors.full_messages.first
        redirect_to cart_path
        return false
      else
        return true
      end
    end

    def customer_only
      # redirect_to(cart_path, alert: :admin_denied) if user_signed_in? and current_user.userable.owner?
    end

    def authenticate_to_buy!
      authenticate_user! unless current_store.config.authenticate_to_buy
    end

    def start
      order = current_order 
      CheckoutService.place_items(order, current_cart)  
      redirect_to address_checkouts_path(store_id: current_store, order_id: order) 
    end
      
    def address
      @order = current_order 
      if request.get?
        respond_to do |wants|
          wants.html do 
            render :address_shipping, layout: 'checkout'
          end 
        end
      elsif request.put?
        if CheckoutService.place_initial(@order, order_params, current_user)# and CheckoutService.place_shipping_address(@order, order_params)
          respond_to do |wants|
            wants.html { redirect_to shipping_checkouts_path(current_store, @order) }
          end
        else
          respond_to do |wants|
            wants.html { render :address_shipping, layout: 'checkout' }
          end
        end
      end
    end

    def shipping
      @order = current_order
      if request.get?
        respond_to do |wants|
          wants.html { render :shipping_method, layout: 'checkout' }
        end
      elsif request.put?
        if CheckoutService.place_second(@order, order_params)
          respond_to do |wants|
            wants.html { redirect_to payment_checkouts_path(current_store, @order) }
          end
        else
          respond_to do |wants|
            wants.html { render :shipping_method, layout: 'checkout' }
          end
        end   
      end
    end

    def payment
      @order = current_order
      if request.get?
        respond_to do |wants|
          wants.html { render :payment_method, layout: 'checkout' }
        end
      elsif request.put?
        if CheckoutService.place_third(@order, order_params)
          if @order.place
            before_order_placed if charge? 
          else
            @order = current_order
            flash[:alert] = @order.errors.full_messages.join(" / ")
            render :complete, layout: 'checkout'
          end
        else
          respond_to do |wants|
            @order = current_order
            wants.html { render :payment_method, layout: 'checkout' }
          end
        end   
      end
    end

    # def address
    #   @order = current_order
    #   @image = @order.assets.new
    #   if request.get?
    #     @order.shipping_address = current_user.userable.try(:addresses).try(:first).try(:dup) if user_signed_in?
    #     render :address, layout: 'checkout'
    #   elsif request.put?
    #     @order.shipping_checkbox = params[:order][:shipping_checkbox]
    #     @order.billing_checkbox = params[:order][:billing_checkbox]
    #     if user_signed_in? and not current_user.userable.owner?
    #       @order.customer_name = current_user.userable.name
    #       @order.customer_email = current_user.email
    #       @order.user = current_user
    #     else
    #       @order.customer_name = params[:order][:customer_name]
    #       @order.customer_email = params[:order][:customer_email]
    #     end
    #     CheckoutService.place_address(@order, order_params)
    #     unless @order.save
    #       render :address, layout: 'checkout'
    #     else          
    #       redirect_to confirm_checkout_path(@order)
    #     end
    #   end
    # end

    # def confirm
    #   @order = current_store.orders.find(params[:id])
    #   if @order.placed? or @order.canceled?
    #     redirect_to complete_checkout_path(id: @order)
    #   elsif request.get?
    #     render :confirm
    #   elsif request.put?
    #     CheckoutService.place_order(@order, order_params)
    #     unless CheckoutService.place_coupons(@order, current_cart, current_store)
    #       flash[:alert] = t(:coupon_not_valid)
    #       render :confirm and return false
    #     end
    #     if not @order.deliverable? 
    #       flash[:alert] = @order.errors.full_messages.join
    #       redirect_to cart_path
    #     elsif @order.chargeable? and @order.save
    #       @order.place if charge?
    #     else
    #       flash[:alert] = @order.errors.full_messages.join(" / ")
    #       render :confirm
    #     end
    #   end
    # end

    def charge?
      begin
        @order = current_store.orders.find(params[:order_id])
        @invoice = @order.invoice
        @prepare = @invoice.prepare
        send("#{@invoice.payment_method.handle}".to_underscore)
        return true
      rescue Exception => msg
        flash[:alert] = t(:checkout_charge_problem)
        render :payment_method, layout: 'checkout' 
        return false
      end
    end

    def custom
      redirect_to complete_checkouts_url(host: current_store.url_site, store_id: current_store.id, order_id: @order.id)
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
      @order = current_order
      @order.payment_url = payment_url(@order)
      @items = @order.items.map {|item| CartItemDrop.new(item)}      
      render 'complete', layout: 'checkout', locals: {order: OrderDrop.new(@order)}
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
      redirect_to complete_checkouts_url(host: current_store.url_site, store_id: current_store.id, order_id: @order.id)
    end

    def return_pd
      invoice = Imentore::Invoice.find(params[:invoice_id])
      @order = invoice.order
      current_store = invoice.order.store
      notificacao = PagamentoDigital::Notificacao.new(params, invoice.payment_method.options['token'])
      invoice.confirm if notificacao.status == :concluida
      redirect_to complete_checkouts_url(host: current_store.url_site, store_id: current_store.id, order_id: @order.id)
    end

    protected

      def order_params
        params.require(:order).permit(:customer_name, :customer_email, :billing_checkbox, :shipping_checkbox, :same_billing_address,
                                      shipping_address: [:name, :street, :complement, :city, :country, :state, :zip_code, :phone], 
                                      billing_address: [:name, :street, :complement, :city, :country, :state,:zip_code, :phone],
                                      delivery_attributes: [:id, :delivery_method_id],
                                      invoice_attributes: [:id, :payment_method_id])
      end

      def check_order
        unless current_store.orders.find_by_id(params[:order_id])      
          redirect_to checkouts_path
        end
      end

      def before_order_placed
        session[:order_id] = nil
        current_cart.try(:destroy)
      end

      def current_order
        order = current_store.orders.find_by_id(params[:order_id]) || current_store.orders.find_by_id(session[:order_id])
        current_order = if order.nil?# or order.placed?
                          order = current_store.orders.new
                          order.save(validate: false) 
                          session[:order_id] = order.id
                          order
                        else
                          order
                        end   
      end

  end
end