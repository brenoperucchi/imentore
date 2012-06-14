module SendEmailHelper
  include ActionView::Helpers
  attr_accessor :output_buffer

  def order_info(send_email, order)
    ret = capture do
      content_tag(:div, id:'customer', class:'box') do
        content_tag(:h4, 'Customer' )
        content_tag(:ul, style:'list-style-type:none') do
          content_tag(:li, id:'customer-name') do
            "Client name: #{order.customer_name}"
          end
          content_tag(:li, id:'customer-email') do
            "Client email: #{order.customer_email}"
          end
        end
      end
    end
    return ret
  end

  def delivery_tracking(send_email, order)
    ret = capture do
      content_tag(:div, id:'customer', class:'box') do
        content_tag(:hr, size:1)
        content_tag(:ul, style:'list-style-type:none') do
          content_tag(:h4, "Tracking")
          content_tag(:hr, size:1)
          content_tag(:li, id:'customer-name') do
            link_to('Rastreamento do Envio', "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI=#{order.delivery.tracking_code}")
          end
        end
      end
    end
    return ret
  end

end
