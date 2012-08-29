module Imentore
  module DealAdmin
    class DashboardController < DealAdmin::BaseController
      inherit_resources
      defaults :resource_class => Dealer, :collection_name => 'dealers', :instance_name => 'dealer'

      # before_filter :authenticate_dealer!
      skip_before_filter :current_store, :check_store, :current_cart

      def index
        @projects = current_dealer.projects
        @talents = current_dealer.talents
      end

      def begin_of_association_chain
        current_dealer
      end


      # actions :index
      # def new
      #   unless current_order
      #     order = current_store.orders.create
      #     session[:order_id] = order.id
      #   end

      #   @order = current_order
      #   @order.update_attribute(:items, current_cart.items)
      # end

      # def confirm
      #   @order = current_order
      #   Dashboardervice.place_order(@order, params[:order])

      #   unless @order.chargeable?
      #     redirect_to complete_checkout_path
      #   end
      # end

      # def complete
      # end

      # protected

      # def current_order
      #   @current_order ||= current_store.orders.find_by_id(session[:order_id])
      # end
    end
  end
end