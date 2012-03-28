module Imentore
  module Admin
    class DomainsController < Admin::BaseController
      inherit_resources
      actions :index, :create, :destroy

      def index
        build_resource
        index!
      end

      def create
        @domain = current_store.domains.build(params[:domain])
        if @domain.add_domain_plesk
          create! { admin_domains_path }
        else
          flash[:notice] = @domain.errors.full_messages.first
          redirect_to admin_domains_path
        end
      end

      def destroy
        @domain = current_store.domains.find(params[:id])
        if @domain.del_domain_plesk
          destroy! { admin_domains_path }
        else
          flash[:notice] = @domain.errors.full_messages.first
          redirect_to admin_domains_path
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end