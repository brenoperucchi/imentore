module Imentore
  module CheckoutService
    extend self

    def place_order(order, params = {})
      store = order.store
      order.status = "placed"

      if order.chargeable?
        payment_method = store.payment_methods.find(params[:payment_method])
        order.build_invoice(amount: order.total_amount, payment_method: payment_method)
      end

      if order.deliverable?
        delivery_method = store.delivery_methods.find(params[:delivery_method])
        order.build_delivery(address: order.shipping_address, delivery_method: delivery_method)
      end

      order.save
    end
  end
end
