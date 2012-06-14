module Imentore
  module CheckoutService
    extend self

    def place_coupons(order, cart, store)
      ret = true
      cart.coupons.each do |coupon|
        limit = 0
        limit += order.customer_email.present? ? store.coupons_orders.find_all_by_email(order.customer_email).size : 0
        limit += order.user_id.present? ? store.coupons_orders.find_all_by_user_id(order.user_id).size : 0
        if coupon.limit_customer
          cart.coupons_orders.find_by_coupon_id(coupon.id).destroy if limit > coupon.limit_customer
          return false if limit > coupon.limit_customer
        end
        if coupon.limit_use
          cart.coupons_orders.find_by_coupon_id(coupon.id).destroy if limit > coupon.limit_use
          return false if limit > coupon.limit_use
        end
        if coupon.due_at
          cart.coupons_orders.find_by_coupon_id(coupon.id).destroy if coupon.due_at.to_date < Date.today
          return false if coupon.due_at.to_date < Date.today
        end
      end
      cart.coupons_orders.each do |c|
        c.update_attributes(order: order, email: order.customer_email, user_id: order.user_id)
      end
      return ret
    end

    def place_order(order, params = {})
      store = order.store
      order.place

      if order.deliverable?
        delivery_method = store.delivery_methods.find_by_id(params[:order][:delivery][:delivery_method])
        order.delivery.nil? ? order.build_delivery(address: order.shipping_address, delivery_method: delivery_method) : order.delivery.update_attributes(address: order.shipping_address, delivery_method: delivery_method)
      end

      if order.chargeable?
        payment_method = store.payment_methods.find_by_id(params[:order][:invoice][:payment_method])
        order.invoice.nil? ? order.build_invoice(amount: order.total_amount, payment_method: payment_method) : order.invoice.update_attributes(amount: order.total_amount, payment_method: payment_method)
      end

      order.save(:validate => false)
    end
  end
end
