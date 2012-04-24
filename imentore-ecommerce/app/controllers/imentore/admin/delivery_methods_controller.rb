module Imentore
  module Admin
    class DeliveryMethodsController < BaseController
      inherit_resources
      actions :all, except: [:show]

      def update
        update! { admin_delivery_methods_path }
      end

      def create
        create! { edit_admin_delivery_method_path(@delivery_method) }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
