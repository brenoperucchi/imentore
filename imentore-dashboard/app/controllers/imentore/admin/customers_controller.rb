module Imentore
  module Admin
    class CustomersController < BaseController
      inherit_resources

      def index
        @customers = current_store.customers.paginate(:page => params[:page], per_page: 10).order(sort_column + " " + sort_direction)
      end

      def edit
        @customer = current_store.customers.find(params[:id])
        (@customer.addresses = [@customer.addresses.new]) if @customer.addresses.blank?
        edit!
      end

      def update
        update! { admin_customers_path }
      end

      def destroy
        destroy! { admin_customers_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end

    end
  end
end
