module Imentore
  module Admin
    class PagesController < BaseController
      inherit_resources

      def create
        create! { admin_pages_path }
      end
      def update
        update! { admin_pages_path }
      end
      def destroy
        destroy! { admin_pages_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
