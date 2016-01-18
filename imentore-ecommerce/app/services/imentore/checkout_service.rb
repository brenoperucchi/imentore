module Imentore
  module CheckoutService
    extend self

    def place_items(order, cart)
      order.items = cart.items unless order.placed?
      order.save(validate: false)
    end

    def place_initial(order, params, current_user)
      order.validate_step = :initial
      shipping_address = Imentore::Address.new(params[:shipping_address])if params[:shipping_address].present?
      order.shipping_address = shipping_address
      if current_user and not current_user.userable.owner?
        order.customer_name = current_user.userable.name
        order.customer_email = current_user.email
        order.user = current_user
      else
        order.customer_name = params[:customer_name]
        order.customer_email = params[:customer_email]
      end
      order.save 
    end

    def place_second(order, params)
      order.validate_step = :second
      order.build_delivery if order.delivery.nil?
      order.delivery.attributes = { delivery_method_id: params[:delivery][:delivery_method] } if params[:delivery].present?
      order.delivery.amount = order.delivery_calculate(order.zip_code, order.delivery_method).try(:cost)
      order.save
    end

    def place_third(order, params)
      order.validate_step = :third
      order.same_billing_address = params[:same_billing_address]
      
      order.billing_address = Imentore::Address.new(params[:billing_address]) if params[:billing_address].present? and order.same_billing_address
      order.billing_address = order.shipping_address unless order.same_billing_address

      order.build_invoice if order.invoice.nil?
      order.attributes = {invoice_attributes: params[:invoice_attributes]} if params[:invoice_attributes].present?
      order.invoice.amount = order.total_amount
      if order.placed? or order.canceled?
        return true
      else
        order.save
      end
    end

    # def place_coupons(order, cart, store)
    #   cart.coupons.each do |coupon|
    #     limit = order.customer_email.present? ? store.coupons_orders.find_all_by_email(order.customer_email).size : 0
    #     limit += order.user_id.present? ? store.coupons_orders.find_all_by_user_id(order.user_id).size : 0
    #     if coupon.limit_customer
    #       cart.coupons_orders.find_by_coupon_id(coupon.id).destroy if limit > coupon.limit_customer
    #       return false if limit > coupon.limit_customer
    #     end
    #     if coupon.limit_use
    #       cart.coupons_orders.find_by_coupon_id(coupon.id).destroy if limit > coupon.limit_use
    #       return false if limit > coupon.limit_use
    #     end
    #     if coupon.due_at
    #       cart.coupons_orders.find_by_coupon_id(coupon.id).destroy if coupon.due_at.to_date < Date.today
    #       return false if coupon.due_at.to_date < Date.today
    #     end
    #   end
    #   cart.coupons_orders.each do |c|
    #     c.update_attributes(order: order, email: order.customer_email, user_id: order.user_id)
    #   end
    #   return true
    # end

  end
end