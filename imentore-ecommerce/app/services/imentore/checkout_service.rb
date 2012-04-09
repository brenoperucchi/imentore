module Imentore
  module CheckoutService
    extend self

    def place_order(order, options = {})
      order.status = "placed"

      if order.chargeable?
        order.invoice = Invoice.new
      end

      if order.shipable?
        order.delivery = Delivery.new
      end

      order.save
    end
  end
end
