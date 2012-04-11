module Imentore
  module CheckoutService
    extend self

    def place_order(order, params = {})
      store = order.store
      order.status = "placed"

      if order.chargeable?
        # payment_method = store.payment_methods.find(params[:payment_method_id])
        payment_method = nil
        order.build_invoice(amount: order.total_amount, payment_method: payment_method)
      end

      # if order.deliverable?
      #   order.delivery = Delivery.new
      # end

      order.save
    end
  end
end
