module AdminImentore
  class SendEmailsController < AdminImentore::BaseController
    inherit_resources
    defaults :resource_class => AdminImentore::SendEmail, :collection_name => 'send_emails', :instance_name => 'send_email'

    def new
      new!
    end

    def edit
      edit!
    end

    def create
      create! { admin_imentore_send_emails_path }
    end

    def update
      update! { admin_imentore_send_emails_path }
    end

    def destroy
      destroy! { admin_imentore_send_emails_path }
    end

    def update_stores
      admin_send_email = AdminImentore::SendEmail.find(params[:id])
      Imentore::Store.all.each do |store|
        send_email = store.send_emails.find_or_initialize_by_name(admin_send_email.name)
        send_email.active = true
        send_email.subject = admin_send_email.subject
        send_email.body = admin_send_email.body
        send_email.save
      end
      flash[:success] = "Successfully created..."
      redirect_to admin_imentore_send_emails_path
    end
  end
end