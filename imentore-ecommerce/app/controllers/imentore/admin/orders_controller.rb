module Imentore
  module Admin
    class OrdersController < BaseController
      inherit_resources
      custom_actions :resource => :confirm_invoice
      # actions :index, :new, :create, :edit, :update
      respond_to :json, :html

      def index
        # orders = current_store.orders.search(params[:id], params[:condition], params[:created_at], params[:email])
        # @orders = orders.paginate(:page => params[:page], per_page: 10).order(sort_column + " " + sort_direction)
        index! do |index|
          index.html{@orders = current_store.orders}
          index.json  { render json: OrdersDatatable.new(view_context, current_store) }
        end
      end

      def edit
        @order = current_store.orders.find(params[:id])
        edit!
      end

      def cancel
        @order = current_store.orders.find(params[:id])
        @order.cancel
        redirect_to admin_orders_path
      end

      def confirm_invoice
        @order = current_store.orders.find(params[:id])
        respond_to do |format|
          if @order.invoice.confirm
            @html = view_context.render 'imentore/admin/orders/actions'
            format.html { redirect_to edit_admin_order_path(@order) }
            format.json { render json: { message: "success", html: @html}, :status => 200 }
          else
            format.html { redirect_to edit_admin_order_path(@order) }
            format.json { render json: { error: @order.invoice.errors.full_messages.join(',')}, :status => 400 }
          end
        end
        
      end

      def confirm_delivery
        @order = current_store.orders.find(params[:id])
        @order.delivery.update_attribute(:tracking_code, params[:delivery][:tracking_code])
        respond_to do |format|
          if @order.delivery.sent or not @order.delivery.status_changed?
            @html = view_context.render 'imentore/admin/orders/actions'
            format.html { redirect_to edit_admin_order_path(@order) }
            format.json { render json: { message: "success", html: @html}, :status => 200 }
          else
            format.html { redirect_to edit_admin_order_path(@order) }
            format.json { render json: { error: @order.delivery.errors.full_messages.join(',')}, :status => 400 }
          end
        end
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
