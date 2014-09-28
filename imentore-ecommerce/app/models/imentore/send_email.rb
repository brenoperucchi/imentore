module Imentore

  class SendEmail < ActiveRecord::Base
    include SendEmailHelper
    belongs_to :store

    attr_accessor :frame, :topic

    def prepare(object)
      prepare_order_change(object) if object.is_a?(Imentore::Order) 
      prepare_customer_created(object) if object.is_a?(Imentore::Customer) 
      self
    end

    def prepare_order_change(order)
      current_store = store
      tracking = delivery_tracking(self, order)
      order_products = helper_orders_products(order)
      order_delivery = helper_delivery(order)
      order_invoice = helper_invoice(order)
      tags = { "#empresa_telefone#" => current_store.address.phone, "#empresa_endereco#" => current_store.address.to_s, "#empresa_nome#" => current_store.brand, "#empresa_url#" => current_store.config.site, "#empresa_nome_loja#" => current_store.name, "#empresa_email#" => current_store.email_contact, "#cliente_nome#"=> order.customer_name,  "#cliente_email#"=> order.customer_email, "#pedido_codigo#" => order.id , "#pedido_data#" => order.created_at, "#link_rastreamento#" => tracking, "#pedido_produtos#" => order_products, "#pedido_entrega#" => order_delivery, "#pedido_valor#" => number_to_currency(order.total_amount), "#pedido_pagamento#" => order_invoice, "#pedido_codigo_rastreamento#" => order.delivery.tracking_code }
      # case name
      # when "order_placed", "invoice_paid"
      # when "delivery_sent"
      #   delivery_tracking(self, order)
      #   tags = { "#empresa_telefone#" => current_store.address.phone, "#empresa_endereco#" => current_store.address.to_s, "#empresa_nome#" => current_store.brand, "#empresa_url#" => current_store.config.site, "#empresa_nome_loja#" => current_store.name, "#empresa_email#" => current_store.email_contact, "#cliente_nome#"=> order.customer_name,  "#cliente_email#"=> order.customer_email, "#pedido_codigo#" => order.id , "#pedido_data#" => order.created_at, "#link_rastreamento#" => tracking, "#pedido_produtos#" => order_products, "#pedido_entrega#" => order_delivery, "#pedido_valor#" => number_to_currency(order.total_amount), "#pedido_pagamento#" => order_invoice, "#pedido_codigo_rastreamento#" => order.delivery.tracking_code }
      # end
      self.frame = body.gsub!(/(#[^#]+#)/){|name| tags[name]}
      self.topic = subject.gsub!(/(#[^#]+#)/){|name| tags[name]}

    end

    def prepare_customer_created(customer)
      current_store = store
      tags = { "#empresa_nome#" => current_store.brand, "#empresa_url#" => current_store.config.site, "#empresa_nome_loja#" => current_store.name, "#empresa_email#" => current_store.email_contact, "#cliente_nome#"=> customer.name,  "#cliente_email#"=> customer.user.email }
      self.frame = body.gsub!(/(#[^#]+#)/){|name| tags[name]}
      self.topic = subject.gsub!(/(#[^#]+#)/){|name| tags[name]}
    end

  end
end
