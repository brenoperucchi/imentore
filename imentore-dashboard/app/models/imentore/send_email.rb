module Imentore

  class SendEmail < ActiveRecord::Base
    include SendEmailHelper
    belongs_to :store

    def prepare_body(order)
      current_store = store
      @order_info = order_info(self, order)
      @tracking = delivery_tracking(self, order)
      case name
      when "order_placed", "invoice_paid"
        tags = { "#empresa_nome#" => current_store.brand, "#empresa_url#" => current_store.config.site, "#empresa_nome_loja#" => current_store.name, "#empresa_email#" => current_store.email_contact, "#cliente_nome#"=> order.customer_name,  "#cliente_email#"=> order.customer_email, "#pedido_codigo#" => order.id , "#pedido_data#" => order.created_at, "#pedido_info_cliente#"=> @order_info }
          #, "#pedido_produtos#" => order_products, "#pedido_frete#" => order_shippings, "#link_rastreamento#" => ""
      when "delivery_sent"
        delivery_tracking(self, order)
        tags = {"#empresa_nome#" => current_store.brand, "#empresa_url#" => current_store.config.site, "#empresa_nome_loja#" => current_store.name, "#empresa_email#" => current_store.email_contact, "#cliente_nome#"=> order.customer_name,  "#cliente_email#"=> order.customer_email, "#pedido_codigo#" => order.id , "#pedido_data#" => order.created_at, "#pedido_info_cliente#"=> @order_info,"#link_rastreamento#" => @tracking }
        # "#pedido_produtos#" => order_products, "#pedido_frete#" => order_shippings,
      end
      body.gsub!(/(#[^#]+#)/){|name| tags[name]}
      return body
    end

  end
end
