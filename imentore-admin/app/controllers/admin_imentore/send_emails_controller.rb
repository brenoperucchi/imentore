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
      stores_send_emails = admin_send_email.stores_send_emails        
      stores_send_emails.each do |send_email| 
        send_email.body_default = admin_send_email.body
        send_email.body_default_updated_at = DateTime.now.utc
        send_email.save
      end
      flash[:success] = "Successfully created..."
      redirect_to admin_imentore_send_emails_path
    end
  end
end