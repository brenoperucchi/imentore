module Imentore
  class Delivery < ActiveRecord::Base
    belongs_to :order
    belongs_to :delivery_method

    validates :delivery_method, presence: true

    state_machine :status, :initial => :pending do
      after_transition :do => lambda {|obj| obj.order.update_status }
      event :sent do
        transition :pending => :sent
      end
    end
  end
end
