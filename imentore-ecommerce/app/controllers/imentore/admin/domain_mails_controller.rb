module Imentore
  module Admin
    class DomainMailsController < Admin::BaseController
      inherit_resources
      # actions :index, :create, :destroy

      def index
        build_resource
        index!
      end

      def create
        @domain_mail = current_store.domains.find(params[:domain_id]).build(params[:domain_mail])
        if @domain_mail.add_mail_domain_plesk
          create! { admin_domain_domain_mails_path(params[:domain_id]) }
        else
          flash[:notice] = @domain_mail.errors.full_messages.first
          redirect_to admin_domain_domain_mails_path(params[:domain_id])
        end
      end

      def destroy
        @domain_mail = Imentore::DomainMail.find(params[:id])
        if @domain_mail.del_mail_domain_plesk
          destroy! { admin_domain_domain_mails(params[:domain_id]) }
        else
          flash[:notice] = @domain.errors.full_messages.first
          redirect_to admin_domain_domain_mails(params[:domain_id])
        end
      end

      protected

      # def begin_of_association_chain
      #   current_store
      # end
    end
  end
end