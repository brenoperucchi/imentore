module Imentore
  module Deal
    class DealersController < BaseController
      inherit_resources
      defaults :resource_class => Dealer, :collection_name => 'dealers', :instance_name => 'dealer'
      skip_before_filter :current_store, :check_store, :current_cart
      # belongs_to :talent, :project, :polymorphic => true


      def index
        @projects = Imentore::Project.all
        @talents = Imentore::Talent.all
      end

      def create
        create! { deal_path }
      end

      def new
          @dealer = Imentore::Dealer.new
          @dealer.talents.build
          new!
      end

      # def show
      #   @dealer = Imentore::Dealer.new
      #   show!
      # end

      # def index
      #   @dealer = Imentore::Dealer.new
      # end


      # def resource
        # Imentore::Dealer
      # end

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