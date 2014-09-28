class CustomerObserver < ActiveRecord::Observer
  observe Imentore::Customer

  def after_create(klass)
    store = klass.store
    send_email = store.send_emails.find_by_name('customer_create').prepare(klass)
    if send_email.active?
      Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,
                                                 klass.user.email, send_email.topic, send_email.frame).deliver
    end
  end
end