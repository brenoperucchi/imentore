module Imentore
  class PaymentMethod::Cielo
    def self.options
      @options ||= [:client_id, :password]
    end

    def initialize(options = {})
      @options = options
    end

    def valid?
      true
    end
  end
end
