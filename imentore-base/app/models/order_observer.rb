class OrderObserver < ActiveRecord::Observer
  observe Imentore::Order

  def after_save(order)
    if order.placed?# and not order.sent_email
      order.sent_email = true
      store = order.store
      send_email = store.send_emails.find_by_name('order_placed').prepare(order)
      if send_email.active?
        Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
                                                 order.customer_email, send_email.topic, send_email.frame).deliver
      end
    end
  end
end