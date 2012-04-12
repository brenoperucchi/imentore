module Imentore
  module Admin
    class DomainEmailsController < Admin::BaseController
      before_filter  :require_domain

      def index
        @emails = @domain.emails
      end

      def create
        plesk = Imentore::Plesk.new
        response = plesk.add_mail_domain(@domain.plesk_id, params[:name], params[:password])
        if response.success?
          @domain.emails = @domain.emails.merge(params[:name] => response.plesk_id)
          @domain.save
        end
        @emails = @domain.emails
        redirect_to admin_domain_emails_path(@domain)
      end

      def destroy
        plesk = Imentore::Plesk.new
        response = plesk.del_mail_domain(@domain.plesk_id, params[:id])
        if response.success?
          @domain.emails.delete(params[:id])
          @domain.save
        end
        redirect_to admin_domain_emails_path(@domain)
      end

      def update
        plesk = Imentore::Plesk.new
        response = plesk.change_mail_domain(@domain.plesk_id, params[:id], params[:password])
        response.success? ? flash[:notice] = "Successfully on action" : flash[:notice] = "Error on action" if response
        @emails = @domain.emails
        redirect_to admin_domain_emails_path(@domain)
      end

      private

      def require_domain
        @domain = current_store.domains.find(params[:domain_id])
      end

    end
  end
end