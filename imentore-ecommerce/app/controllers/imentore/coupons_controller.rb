module Imentore
  class CouponsController < BaseController

    skip_before_action :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    respond_to :json, only: [:add_coupon]

    def add_coupon
      respond_to do |wants|
        wants.json do
          coupon = current_store.coupons.active.find_by_code(params[:coupon_code])
          return render nothing: true, status: 200 if coupon.nil?
          if coupon.check_valid?
            Imentore::CouponsOrder.add(current_cart, coupon)

            # current_cart.coupon = coupons.add(coupon)
            # current_cart.save
            render :status => 200, :json => current_cart.coupons.to_json
          else
            render nothing: true, status: 200
          end
        end
      end
    end
  end
end
