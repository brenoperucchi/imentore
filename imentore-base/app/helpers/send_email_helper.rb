module SendEmailHelper
  include ActionView::Helpers
  attr_accessor :output_buffer

  def helper_orders_products(order)
    ret = capture do
      content_tag(:div, id:'products', class:'box') do
        content_tag(:h4, 'Products' )
        (content_tag(:ul, style:'list-style-type:none') do
          order.items.each do |item| 
            concat(content_tag(:li, id:'product-item') do
              I18n.t(:line_item, scope: 'helpers.send_mail.products', code: "#{item.product.id}-#{item.variant.id}", item: item.name, quantity: item.quantity, value: number_to_currency(item.value), amount: number_to_currency(item.amount)) 
            end)
          end
        end)
      end
    end
    return ret    
  end

  def helper_delivery(order)
    ret = capture do
      content_tag(:div, id:'shipping', class:'box') do
        concat(content_tag(:ul, style:'list-style-type:none') do
          concat(content_tag(:li, id:'shipping-name') do
            I18n.t(:shipping, scope: 'helpers.send_mail.delivery', code: order.delivery.id, status: I18n.t(order.delivery.status), method: order.delivery.delivery_method.name, address: order.shipping_address.to_s , amount: number_to_currency(order.delivery.amount)) 
          end)
          concat(content_tag(:li, id:'customer-name') do
            I18n.t(:message) + ": " + order.delivery.delivery_method.description.to_s
          end)

        end)
      end
    end
    return ret
  end

  def helper_invoice(order)
    ret = capture do
      content_tag(:div, id:'invoice', class:'box') do
        concat(content_tag(:ul, style:'list-style-type:none') do
          concat(content_tag(:li, id:'invoice-name') do
            I18n.t(:invoice, scope: 'helpers.send_mail.invoice', code: order.invoice.id, status: I18n.t(order.invoice.status), method: order.invoice.payment_method.name, address: order.billing_address.to_s , amount: number_to_currency(order.invoice.amount)) 
          end)
          concat(content_tag(:li, id:'customer-name') do
            I18n.t(:message) + ": " + order.invoice.payment_method.description.to_s
          end)

        end)
      end
    end
    return ret
  end

  def helper_delivery_tracking(send_email, order)
    ret = capture do
      content_tag(:div, id:'customer', class:'box') do
        content_tag(:hr, size:1)
        content_tag(:ul, style:'list-style-type:none') do
          content_tag(:h4, t('imentore/delivery_method', scope: 'activerecord.models'))
          content_tag(:hr, size:1)
          content_tag(:li, id:'customer-name') do
            link_to('Rastreamento do Envio', "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI=#{order.delivery.try(:tracking_code)}")
          end
        end
      end
    end
    return ret
  end

end