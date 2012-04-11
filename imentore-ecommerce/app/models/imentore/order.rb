module Imentore
  class Order < ActiveRecord::Base
    attr_accessor :delivery
    serialize :items, Array

    has_one     :invoice
    belongs_to  :store

    def total_amount
      items.sum(&:price)
    end

    def chargeable?
      total_amount > 0
    end

    def deliverable?
      items.map(&:deliverable?).inject(:&)
    end
  end
end
