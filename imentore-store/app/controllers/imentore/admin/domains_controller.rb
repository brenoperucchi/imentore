module Imentore
  module Admin
    class DomainsController < BaseController
      inherit_resources
      actions :index, :create, :destroy

      def index
        @domain = begin_of_association_chain.domains.build
      end

      def create
        create! { admin_domains_path }
      end

      def destroy
        @domain = params[:params] 
        destroy! { admin_domains_path }
      end

      def begin_of_association_chain
        @current_store = current_store
      end

      protected
      
      def collections
        @domains = current_store.domains
      end

    end
  end
end