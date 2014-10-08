module Imentore
  class DeliveryMethod::Base

    attr_accessor :message_success, :message_error

    def initialize(options = {})
      @options = options
    end

    def value(amount = 0 , weight = 0)
      value = 0
      fixed_rate = Delocalize::LocalizedNumericParser.parse(@options['fixed_rate']).to_f
      percent_rate = Delocalize::LocalizedNumericParser.parse(@options['percent_rate']).to_f
      value += amount * (percent_rate / 100) unless percent_rate == 0
      value += fixed_rate unless fixed_rate == 0
      return value
    end

    def calculate(item ,zip_code, store_zip, amount = 0 , weight = 0)
      value
    end

  end
end
