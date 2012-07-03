module Imentore
  module Admin
    class NoticesController < BaseController
      inherit_resources

      def create
        create! { admin_notices_path }
      end
      def update
        update! { admin_notices_path }
      end
      def destroy
        destroy! { admin_notices_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
