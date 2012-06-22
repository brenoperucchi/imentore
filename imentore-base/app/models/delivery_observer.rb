class DeliveryObserver < ActiveRecord::Observer
  observe Imentore::Delivery

  def after_update(klass)
    if klass.sent?
      store = klass.order.store
      send_email = store.send_emails.find_by_name('delivery_sent')
      if send_email.active?
        body = send_email.prepare_body_order(klass.order)
        Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
                                                 klass.order.customer_email, send_email.subject, body).deliver
      end
    end
  end
end