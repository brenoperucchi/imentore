module Imentore
  class DeliveryMethod::Base

    attr_accessor :error, :message, :cost, :delivery_time

    def initialize(options = {})
      @options = options
      @delivery_time = 0
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
      @cost = value(amount, weight).round(2)
      @error = false
      @message = I18n.t(:valid!, scope:'helpers.delivery_method.calculate')
      @delivery_time = nil
      self
    end

  end
end
