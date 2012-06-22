module Imentore
  module Admin
    class OrdersController < BaseController
      inherit_resources
      custom_actions :resource => :confirm_invoice
      # actions :index, :new, :create, :edit, :update

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

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
