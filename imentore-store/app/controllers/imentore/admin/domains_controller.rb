module Imentore
  module Admin
    class DomainsController < BaseController
      inherit_resources
      actions :index

      def index
        @domains = current_store.domains
      end

      def resource
        @domains = current_store.domains
      end

    end
  end
end