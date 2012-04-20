module Imentore
  class PaymentMethod::Cielo
    def self.options
      @options ||= [:client_id, :password]
    end

    def initialize(options = {})
      @options = options
    end
  end
end
