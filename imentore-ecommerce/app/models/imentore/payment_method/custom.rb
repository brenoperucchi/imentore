module Imentore
  class PaymentMethod::Custom
    def self.options
      @options ||= [:client_id, :password]
    end

    def initialize(options = {})
      @options = options
    end

    def valid?
      true
    end

    def checkout(*param)
      {
        'redirect_to' => nil,
        'render' => true,
      }
    end
  end
end
