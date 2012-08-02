module Imentore
  class Coupon < ActiveRecord::Base
    belongs_to :store
    # belongs_to :order
    # belongs_to :cart

    scope :active, where(active: true)
    has_many :coupons_orders
    has_many :coupons, :through => :coupons_orders, :source => :coupon

    validates :value, presence: true

    def check_valid?(*params)
      true
    end

    def value
      ret = (read_attribute(:value) || 0) * -1
      return nil if ret == 0
      ret
    end

  end

end
