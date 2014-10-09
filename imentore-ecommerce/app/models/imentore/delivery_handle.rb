module Imentore
  class DeliveryHandle
    attr_accessor :weight, :amount, :method, :zip_code, :store_zip, :items

    def initialize(items, zip_code, store_zip, delivery_method)
      @items = items
      @zip_code = zip_code
      @store_zip = store_zip
      @method = delivery_method.provider
      @weight = items.sum(&:weight).to_f
      @amount = items.sum(&:amount).to_f
    end

    def calculate
      @method.calculate(items ,zip_code, store_zip, amount, weight)
    end

    def to_json
      {
        "name" => @method,
        "value" => @value,
      }
    end
  end

end