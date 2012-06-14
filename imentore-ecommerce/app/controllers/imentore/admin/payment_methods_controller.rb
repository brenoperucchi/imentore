module Imentore
  module Admin
    class PaymentMethodsController < Admin::BaseController
      inherit_resources

      def new
        @payment_method = build_resource
        @payment_method.handle = 'custom'
      end

      def update
        update! { admin_payment_methods_path }
      end

      def create
        create! do |success, failure|
          success.html{
            @payment_method.update_attribute(:handle, "custom")
            flash[:success] = 'Payment Method Successfully Created '
            redirect_to admin_payment_methods_path
          }
          failure.html{
            @payment_method.handle = 'custom'
            # flash[:alert] = 'Could not updated'
            render :new }
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
