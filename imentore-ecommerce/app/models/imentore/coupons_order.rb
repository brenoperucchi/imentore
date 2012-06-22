module Imentore
  class CouponsOrder < ActiveRecord::Base

    belongs_to :cart
    belongs_to :order
    belongs_to :coupon
    belongs_to :store

    # attr_accessor :coupons, :coupon, :total

    # def initialize(klass = nil)
    #   @coupons = klass.try(:coupons)
    #   @total ||= klass.try(:total)
    #   @coupons ||= []
    # end

    def self.add(klass, coupon)
      size = klass.coupons_orders.find_all_by_coupon_id(coupon).size
      k = klass.coupons_orders.create(:coupon => coupon, store: coupon.store) if size == 0
      # aux = @coupons.detect { |c| c == coupon }
      # if aux.nil?
      #   @coupons << coupon
      #   @total += coupon.value
      # end
      # return self
    end

    # def to_json
    #   { 'total'   => total,
    #     'coupons' => @coupons.map do |c|
    #                  {
    #                   'name' => c.name,
    #                   'value' => c.value
    #                  }
    #                 end
    #   }
    # end

    # def total
    #   @total ||= 0
    # end


  end
end
