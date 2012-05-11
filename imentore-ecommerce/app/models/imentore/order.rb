module Imentore
  class Order < ActiveRecord::Base
    attr_accessor :payment_method, :delivery_method
    serialize :items, Array

    belongs_to  :store
    has_one     :invoice,   dependent: :destroy
    has_one     :delivery,  dependent: :destroy

    def total_amount
      items.sum(&:price)
    end

    def chargeable?
      total_amount > 0
    end

    def deliverable?
      items.map(&:deliverable?).inject(true, :&)
    end
  end
end
