module Imentore
  module Manager
    class SendEmailsController < Manager::BaseController
      inherit_resources
      defaults :resource_class => Manager::SendEmail, :collection_name => 'send_emails', :instance_name => 'send_email'

      def new
        new!
      end

      def edit
        edit!
      end

      def create
        create! { manager_send_emails_path }
      end

      def update
        update! do |format| 
          format.html { redirect_to manager_send_emails_path, success: "Successfully" } 
        end
      end

      def destroy
        destroy! { manager_send_emails_path }
      end

      def update_stores
        admin_send_email = Manager::SendEmail.find(send_emails_params)
        Imentore::Store.all.each do |store|
          send_email = store.send_emails.find_or_initialize_by_name(admin_send_email.name)
          send_email.active = true
          send_email.subject = admin_send_email.subject
          send_email.body = admin_send_email.body
          send_email.save
        end
        redirect_to manager_send_emails_path
      end

      protected
      def send_emails_params
        params.require(:send_emails).permit(:name, :active, :subject, :body)
      end

    end
  end
end