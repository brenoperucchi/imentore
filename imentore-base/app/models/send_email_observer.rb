class SendEmailObserver < ActiveRecord::Observer
  observe Imentore::Order

  def after_update(order)
    if order.placed?
      store = order.store
      send_email = store.send_emails.find_by_name('order_placed')
      body = send_email.prepare_body(order)
      Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
                                                 order.customer_email, send_email.subject, body).deliver
    end
  end
end