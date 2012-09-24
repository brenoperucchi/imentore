class OrderObserver < ActiveRecord::Observer
#   observe Imentore::Order

#   def after_save(order)
#     if order.placed? and not order.sent_email
#       order.sent_email = true
#       store = order.store
#       send_email = store.send_emails.find_by_name('order_placed')
#       if send_email.active?
#         body = send_email.prepare_body_order(order)
#         Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
#                                                  order.customer_email, send_email.subject, body).deliver
#       end
#     end
#   end
end