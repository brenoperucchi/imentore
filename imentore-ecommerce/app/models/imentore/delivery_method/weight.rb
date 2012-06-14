module Imentore
  class DeliveryMethod::Weight < DeliveryMethod::Base

    def calculate(item ,zip_code, store_zip, amount = 0 , weight = 0)
      service = 0
      @options[:weight].each do |range|
        case weight.to_f
        when (range[:initial].to_f..range[:final].to_f)
          service = range[:value].to_f
        else
          service ||= nil
        end
      end
      (service + value(amount, weight)).round(2)
    end

    def self.name
      "weight"
    end

  end
end
