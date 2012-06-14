class InvoiceObserver < ActiveRecord::Observer
  observe Imentore::Invoice

  def after_update(klass)
    if klass.confirmed?
      store = klass.order.store
      send_email = store.send_emails.find_by_name('invoice_paid')
      body = send_email.prepare_body(klass.order)
      Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
                                                 klass.order.customer_email, send_email.subject, body).deliver
    end
  end
end