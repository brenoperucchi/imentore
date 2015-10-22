module Imentore
  module Admin
    class SendEmailsController < Admin::BaseController
      inherit_resources
      
      def edit
        edit!
      end

      def update
        update! { admin_send_emails_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end

      def send_email_params
        params.require(:send_email).permit(:active, :notify, :subject, :body)
      end

    end
  end
end