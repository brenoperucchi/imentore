module Imentore
  module CheckoutService
    extend self

    def place_order(order, params = {}, current_cart)
      store = order.store
      order.status = "placed"

      if params[:order].present?
        order.items = current_cart.items
        order.billing_address = Imentore::Address.new(params[:order][:billing_address]) if params[:order][:billing_address].present?
        order.shipping_address = Imentore::Address.new(params[:order][:shipping_address]) if params[:order][:shipping_address].present?
        order.payment_method = params[:order][:address_checkbox] if params[:order][:address_checkbox].present?
        order.payment_method = params[:order][:payment_method] if params[:order][:payment_method].present?
        order.delivery_method = params[:order][:delivery_method] if params[:order][:delivery_method].present?

        order.billing_checkbox = params[:order][:billing_checkbox] if params[:order][:billing_checkbox]
        order.shipping_checkbox = params[:order][:shipping_checkbox] if params[:order][:shipping_checkbox]
      end


      if order.chargeable? and params[:order][:payment_method].present?
        payment_method = store.payment_methods.find(params[:order][:payment_method])
        order.build_invoice(amount: order.total_amount, payment_method: payment_method)
      end

      if order.deliverable? and params[:order][:delivery_method].present?
        delivery_method = store.delivery_methods.find(params[:order][:delivery_method])
        order.build_delivery(address: order.shipping_address, delivery_method: delivery_method)
      end

      order.save
    end
  end
end
