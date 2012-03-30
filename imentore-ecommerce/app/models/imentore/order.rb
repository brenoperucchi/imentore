module Imentore
  class Order
    attr_accessor :shipping_address, :billing_address, :total_amount, :status,
                  :buyer_email, :items, :invoice, :shipment
  end
end
