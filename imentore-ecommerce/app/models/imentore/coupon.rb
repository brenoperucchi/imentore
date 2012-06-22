module Imentore
  class Coupon < ActiveRecord::Base
    belongs_to :store
    # belongs_to :order
    # belongs_to :cart

    scope :active, where(active: true)

    has_many :coupons_orders
    has_many :coupons, :through => :coupons_orders, :source => :coupon

    def check_valid?(*params)
      true
    end

    def value
      read_attribute(:value) * -1
    end

  end

end
