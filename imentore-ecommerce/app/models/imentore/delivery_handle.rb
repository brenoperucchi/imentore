module Imentore
  class DeliveryHandle
    # attr_accessor :items, :zip_code, :value
    attr_accessor :value, :method

    def initialize(value, method)
      @value, @method = value, method
    end

    def self.calculate_item(item, zip_code, method)
      value = 0
      handle = Imentore::DeliveryCalculate.new(method, zip_code)
      value = handle.calculate(item)
      return self.new(value, method)
    end

    def self.calculate_items(items, zip_code, method)
      value = 0
      handle = Imentore::DeliveryCalculate.new(method, zip_code)
      items.each do |item|
        value += handle.calculate(item)
      end
      return self.new(value, method)
    end

    def to_json
      {
        "name" => @method.name,
        "value" => @value,
        "description" => @method.description,
        # "message" => {
        #               "success" => klass.message_success,
        #               "error" => klass.message_error
        #               }
      }
    end
  end

end