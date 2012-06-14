module Imentore
  module Admin
    class SendEmailsController < Admin::BaseController
      inherit_resources

      def update
        update! { admin_send_emails_path }
      end

      protected
      def begin_of_association_chain
        current_store
      end
    end
  end
end