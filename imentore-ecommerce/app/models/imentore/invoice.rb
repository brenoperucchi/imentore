module Imentore
  class Invoice < ActiveRecord::Base
    belongs_to :payment_method
    belongs_to :order

    validates :payment_method, presence: true

    def prepare
      payment_method.prepare(self.order)
    end

    state_machine :status, :initial => :pending do
      after_transition :do => lambda {|obj| obj.order.update_status }
      event :confirm do
        transition :pending => :confirmed
      end
    end

  end
end
