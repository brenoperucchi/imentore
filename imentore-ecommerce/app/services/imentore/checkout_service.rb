module Imentore
  module CheckoutService
    extend self

    def place_coupons(order, cart, store)
      ret = true
      cart.coupons.each do |coupon|
        limit = order.customer_email.present? ? store.coupons_orders.find_all_by_email(order.customer_email).size : 0
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

    def place_address(order, params={})
      if params[:shipping_address]
        billing_address = Imentore::Address.new(params[:order][:shipping_address]) if params[:order][:shipping_address].present?
        shipping_address = Imentore::Address.new(params[:order][:shipping_address])if params[:order][:shipping_address].present?
      else
        billing_address = Imentore::Address.new(params[:order][:billing_address]) if params[:order][:billing_address].present?
        shipping_address = Imentore::Address.new(params[:order][:shipping_address])if params[:order][:shipping_address].present?
      end
      order.billing_address = billing_address
      order.shipping_address = shipping_address
      order.save(:validate => false) #and order.deliverable?
    end

    def place_order(order, params={})
      store = order.store
      if order.deliverable?
        delivery = order.delivery || order.build_delivery
        delivery.attributes = { address: order.shipping_address, delivery_method_id: params[:order][:delivery][:delivery_method] }
        delivery.amount = order.delivery_calculate(order.zip_code, order.delivery_method)
        delivery.save
      end
      if order.chargeable?
        # delivery.changed.include? "delivery_method_id"
        invoice = order.invoice || order.build_invoice
        invoice.attributes = { amount: order.total_amount, payment_method_id: params[:order][:invoice][:payment_method] }
        invoice.save
      end
      order.save(:validate => false) 
    end
  end
end
