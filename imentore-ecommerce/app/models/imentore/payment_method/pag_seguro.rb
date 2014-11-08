# encoding: utf-8
module Imentore
  class PaymentMethod::PagSeguro
    def self.options
      @options ||= [:client_id, :password]
    end

    def initialize(options = {})
      @options = options
    end

    def billing(order)
      id = Rails.env == "development" ? 1 : order.invoice.id
      ret = { :id => id,
              :name => order.customer_name,
              :email => order.customer_email,
              :phone => order.billing_address.phone,
              :street => order.billing_address.street,
              :complement => order.billing_address.complement,
              :city => order.billing_address.city,
              :state => order.billing_address.state,
              :country => order.billing_address.country,
              :postalCode => order.billing_address.zip_code,
              :currency => "BRL",
              :redirectURL =>  "http://app.imentore.com.br/return_pg/#{order.invoice.id}",
              :shippingType => 3,
              :shippingCost => ("%.2f" % (order.delivery_calculate(order.zip_code, order.delivery.delivery_method)).round(2)),
            }
      ret
    end

    def items(order)
      ret = []
      order.items.each do |item|
        ret << { :id => "#{item.product.id} - #{item.variant.id}",
                 :description => "#{item.name} - ##{item.variant.id}",
                 :amount => ("%.2f" % item.value.to_f),
                 :quantity => item.quantity.to_i,
                }
      end
      ret
    end

    def notification_rpc(notification_code)
      response = PagSeguro.notification_rpc(@options.merge(notification_code))
    end

    def checkout(order = nil)
      billing = billing(order)
      items = items(order)
      @invoice = order.invoice
      response = PagSeguro.prepare(billing, items, @options)
      unless response['checkout'].nil?
        code = response['checkout']['code']
        params = {'redirect_to' => PagSeguro.gateway_payment_url + '?code=' + code }
        @invoice.update_attribute(:provider_id, code)
        response.merge(params)
      end
    end

    def valid?
      true
    end
  end
end