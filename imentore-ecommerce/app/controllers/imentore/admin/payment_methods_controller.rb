module Imentore
  module Admin
    class PaymentMethodsController < BaseController
      inherit_resources
      actions :index, :edit, :update

      def update
        update! { admin_payment_methods_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
