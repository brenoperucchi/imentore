# class CustomerObserver < ActiveRecord::Observer
#   observe Imentore::Customer

#   def after_create(klass)
#     store = klass.store
#     send_email = store.send_emails.find_by_name('customer_create')
#     if send_email.active?
#       body = send_email.prepare_body_customer(klass)
#       Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
#                                                  klass.user.email, send_email.subject, body).deliver
#     end
#   end
# end