# encoding: utf-8
module Imentore
  class PaymentMethod::PagamentoDigital
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
                  :messages => order.items.collect {|item| ["#{item.name} - ##{item.variant.id} - #{item.amount}"]}
                }
    end


    def attributes(order)
      main = {
               'id_pedido' => order.invoice.id,
               'email_loja' => order.invoice_method.options['client_id'],
               'tipo_integraca' => 'PAD',
               'frete' => order.delivery_calculate(order.zip_code, order.delivery_method).value,
               'url_retorno' =>  "http://app.imentore.com.br/return_pd/#{order.invoice.id}",
               'url_aviso' =>  "http://app.imentore.com.br/sync_pd/#{order.invoice.id}",
               'redirect' => 'true',
             }
      products = {}
      order.items.each_with_index do |item, index|
        index = index + 1
        @product = {
                    "produto_codigo_#{index}" => "#{item.product.id} - ##{item.variant.id}",
                    "produto_descricao_#{index}" => "#{item.product.name} - ##{item.variant.id}",
                    "produto_qtde_#{index}" => item.quantity,
                    "produto_valor_#{index}" => item.price.to_f,

                 }
      products = products.merge(@product)
      end
      main.merge(products)
    end

    def checkout(order)
      # attributes = attributes(order).to_a
      # PagamentoDigital.email = order.invoice.payment_method.options['client_id']
      # PagamentoDigital.token = order.invoice.payment_method.options['token']
      # PagamentoDigital.return_to = 'http://imentore.imentore.com.br/sync/pd'

      # pd = PagamentoDigital::Pedido.new
      # pd.id = order.invoice.id
      # # binding.pry
      # order.items.each do |item|
      #   pd.add({peso: item.weight, frete: item.delivery_calculate(order.zip_code, order.delivery_method), taxa:item.amount, quantidade: item.quantity })
      # end
      # url = "?id=5200"
      # attributes[1..-1].each do |attr|
      #   url << "&#{attr[0]}=#{attr[1]}"
      # end
      # params = {'redirect_to' => "https://www.pagamentodigital.com.br/checkout/pay" + url }

      attributes(order)

      # invoice = order.invoice
      # if invoice.provider_id.nil?
      #   MoIP.setup do |config|
      #     config.uri = 'https://desenvolvedor.moip.com.br/sandbox'
      #     config.token = 'Y2SQPDY4UVGUVJ9VPH1HHLDEOLTOKSYR'
      #     config.key = 'N3X5MADINQOXPSW6XBTQKJYUSFI88RNNDGK1C14N'
      #   end
      #   response = MoIP::Client.checkout(attributes(order))
      #   invoice.update_attribute(:provider_id, response['Token'])
      #   params = {'redirect_to' => MoIP::Client.moip_page(response["Token"]) }
      # else
      #   params = {'redirect_to' => MoIP::Client.moip_page(invoice.provider_id) }
      # end
    end

    def valid?
      true
    end
  end
end