# encoding: utf-8
require 'MoIP'

module Imentore
  class PaymentMethod::Moip
    def self.options
      @options ||= [:client_id, :password]
    end

    def initialize(options = {})
      @options = options
    end

    def billing(order)
      # messages << order.items.collect {|item| [valor, "#{item.name} - ##{item.variant.id}"]}
      values = []
      messages = []
      billing = { :nome => order.customer_name,
                  :email => order.customer_email,
                  :tel_cel => order.billing_address.phone,
                  :logradouro => order.billing_address.street,
                  :complemento => order.billing_address.complement,
                  :cidade => order.billing_address.city,
                  :estado => order.billing_address.state,
                  :pais => order.billing_address.country,
                  :cep => order.billing_address.zip_code,
                  :messages => order.items.collect {|item| ["#{item.name} - ##{item.variant.id} - #{item.price.to_f}"]}
                }
    end


    def attributes(order)
      main = { :valor => order.total_amount,
                 :razao => "Compra na Loja: #{order.store.brand} #{order.store.name}",
                 :id_proprio => order.invoice.id,
                 :dias_expiracao => 5,
                 :billing => billing(order),
                 :shippingCost => ("%.2f" % order.delivery_calculate(order.zip_code, order.delivery.delivery_method).value)
             }
    end

    def checkout(order)
      invoice = order.invoice
      if invoice.provider_id.nil?
        MoIP.setup do |config|
          config.uri = 'https://desenvolvedor.moip.com.br/sandbox'
          config.token = 'Y2SQPDY4UVGUVJ9VPH1HHLDEOLTOKSYR'
          config.key = 'N3X5MADINQOXPSW6XBTQKJYUSFI88RNNDGK1C14N'
        end
        response = MoIP::Client.checkout(attributes(order))
        invoice.update_attribute(:provider_id, response['Token'])
        params = {'redirect_to' => MoIP::Client.moip_page(response["Token"]) }
      else
        params = {'redirect_to' => MoIP::Client.moip_page(invoice.provider_id) }
      end
    end

    def valid?
      true
    end
  end
end