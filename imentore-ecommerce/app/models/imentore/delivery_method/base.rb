module Imentore
  class DeliveryMethod::Base

    attr_accessor :message_success, :message_error

    def initialize(options = {})
      @options = options
    end

    def value(amount = 0 , weight = 0)
      value = 0
      value += amount * (@options['percent_rate'].to_f / 100) unless @options['percent_rate'].to_i == 0
      value += @options['fixed_rate'].to_f unless @options['fixed_rate'].to_i == 0
      return value
    end

    def calculate(item ,zip_code, store_zip, amount = 0 , weight = 0)
      value
    end

  end
end
