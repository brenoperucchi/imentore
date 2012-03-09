module Imentore
  module Admin
    class DomainsController < BaseController
      inherit_resources
      actions :index, :create, :destroy

      def index
        build_resource
        index!
      end

      def create
        create! { admin_domains_path }
      end

      def destroy
        destroy! { admin_domains_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end