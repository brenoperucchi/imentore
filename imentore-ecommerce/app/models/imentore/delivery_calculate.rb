module Imentore
  class DeliveryCalculate
    attr_accessor :delivery, :value, :klass, :zip_code

    def initialize(delivery, zip_code)
      @delivery, @zip_code = delivery, zip_code
      @value = 0
    end

    def calculate(item)
      @klass = @delivery.provider
      weight = item.weight.nil? ? 0 : item.weight
      value, error, error_msg = @klass.calculate(item, zip_code, item.store.config.store_zip_code, item.amount, weight)
      return value, error, error_msg
    end

  end
end