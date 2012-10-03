module Imentore
  class DeliveryHandle
    # attr_accessor :items, :zip_code, :value
    attr_accessor :value, :method, :error, :error_msg

    def initialize(value, method, error = nil, error_msg = nil)
      @value, @method, @error, @error_msg = value, method, error, error_msg
    end

    def self.calculate_item(item, zip_code, method)
      value = 0
      error = 0
      error_msg = ""
      handle = Imentore::DeliveryCalculate.new(method, zip_code)
      value, error, error_msg = handle.calculate(item)
      return self.new(value, method.name, error, error_msg)
    end

    def self.calculate_items(items, zip_code, method)
      value = 0
      value_each = 0
      error = 0
      error_msg = ""
      handle = Imentore::DeliveryCalculate.new(method, zip_code)
      items.each do |item|
        value_each, error, error_msg = handle.calculate(item)
        value += value_each
        break unless error == "0" 
      end
      return self.new(value, method.name, error, error_msg)
    end

    def to_json
      {
        "name" => @method,
        "value" => @value,
        # "description" => @method.description,
        # "message" => {
        #               "success" => klass.message_success,
        #               "error" => klass.message_error
        #               }
      }
    end
  end

end