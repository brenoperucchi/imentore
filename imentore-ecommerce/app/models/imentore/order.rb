module Imentore
  class Order < ActiveRecord::Base
    attr_accessor :payment_method
    serialize :items, Array

    has_one     :invoice
    belongs_to  :store
    has_one     :delivery

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
