class DeliveryObserver < ActiveRecord::Observer
  observe Imentore::Delivery

  def after_update(klass)
    if klass.sent?
      store = klass.order.store
      send_email = store.send_emails.find_by_name('delivery_sent').prepare(klass.order)
      if send_email.active?
        Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
                                                 klass.order.customer_email, send_email.topic, send_email.frame).deliver
      end
    end
  end
end