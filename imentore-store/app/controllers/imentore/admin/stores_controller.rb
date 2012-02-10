module Imentore
  module Admin
    class StoresController < BaseController
      inherit_resources
      actions :edit, :update

      def update
        update! { admin_dashboard_path }
      end

      protected

      def resource
        @store ||= current_store
      end
    end
  end
end