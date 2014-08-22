module Imentore
  module Admin
    class OrdersController < BaseController
      inherit_resources
      custom_actions :resource => :confirm_invoice
      # actions :index, :new, :create, :edit, :update

      def index
        # orders = current_store.orders.search(params[:id], params[:condition], params[:created_at], params[:email])
        # @orders = orders.paginate(:page => params[:page], per_page: 10).order(sort_column + " " + sort_direction)
        index! do |index|
          index.html{@orders = current_store.orders}
          index.js 
        end
      end

      def cancel
        @order = current_store.orders.find(params[:id])
        @order.cancel
        redirect_to admin_orders_path
      end

      def confirm_invoice
        @order = current_store.orders.find(params[:id])
        @order.invoice.confirm
        redirect_to edit_admin_order_path(@order)
      end

      def confirm_delivery
        @order = current_store.orders.find(params[:id])
        @order.delivery.sent
        redirect_to edit_admin_order_path(@order)
      end

      def destroy
        destroy! { admin_orders_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
