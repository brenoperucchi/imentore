module Imentore

  class SendEmail < ActiveRecord::Base
    include SendEmailHelper
    belongs_to :store

    attr_accessor :frame, :topic

    def prepare(object)
      @current_store = store
      if object.is_a?(Imentore::Order) 
        prepare_order_change(object) 
        notify_admin(object.customer_name, object.customer_email)
      elsif object.is_a?(Imentore::Customer) 
        prepare_customer_created(object) 
        notify_admin(object.name, object.user.email)
      end 
      self
    end

    def notify_admin(customer_name, customer_email)
      return unless notify
      admin_email = store.send_emails.find_by_name('notify_admin')
      tags = { 
              "#notificacao_loja#" => self.topic,
              "#cliente_nome#"=> customer_name,
              "#cliente_email#"=> customer_email 
              }.merge(tags_common)
      admin_frame = admin_email.body.gsub(/(#[^#]+#)/){|name| tags[name]}
      admin_topic = admin_email.subject.gsub(/(#[^#]+#)/){|name| tags[name]}

      Imentore::SendEmailMailer.send_mail_mailer(@current_store.config.email_contact,
                                                 @current_store.config.email_contact, admin_topic, admin_frame).deliver
    end

    def prepare_order_change(order)
      tracking = helper_delivery_tracking(self, order)
      order_products = helper_orders_products(order)
      order_delivery = helper_delivery(order)
      order_invoice = helper_invoice(order)
      tags = { 
              "#cliente_nome#"=> order.customer_name,  
              "#cliente_email#"=> order.customer_email, 
              "#pedido_codigo#" => order.id , 
              "#pedido_data#" => order.created_at, 
              "#link_rastreamento#" => tracking, 
              "#pedido_produtos#" => order_products, 
              "#pedido_entrega#" => order_delivery, 
              "#pedido_valor#" => number_to_currency(order.total_amount), 
              "#pedido_pagamento#" => order_invoice, 
              "#pedido_codigo_rastreamento#" => order.delivery.try(:tracking_code) 
            }.merge(tags_common)
      self.frame = body.gsub!(/(#[^#]+#)/){|name| tags[name]}
      self.topic = subject.gsub!(/(#[^#]+#)/){|name| tags[name]}

    end

    def prepare_customer_created(customer)
      tags = { 
              "#cliente_nome#"=> customer.name,  
              "#cliente_email#"=> customer.user.email 
            }.merge(tags_common)
      self.frame = body.gsub!(/(#[^#]+#)/){|name| tags[name]}
      self.topic = subject.gsub!(/(#[^#]+#)/){|name| tags[name]}
    end

    private
      def tags_common
        {
          "#empresa_telefone#" => @current_store.address.try(:phone), 
          "#empresa_endereco#" => @current_store.address.try(:to_s), 
          "#empresa_nome#" => @current_store.brand, 
          "#empresa_url#" => @current_store.config.try(:site), 
          "#empresa_nome_loja#" => @current_store.name, 
          "#empresa_email#" => @current_store.email_contact, 
          "#administrador_email#" => @current_store.config.email_contact, 
        }
      end


  end
end
