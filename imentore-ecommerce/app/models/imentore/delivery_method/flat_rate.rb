module Imentore
  class DeliveryMethod::FlatRate
    def self.options
      @options ||= [:amount]
    end

    def self.name
      "Flat rate"
    end

    def initialize(options = {})
      @options = options
    end

    def total_cost(order)
      @options[:amount].to_f
    end
  end
end
