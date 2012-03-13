module Imentore
  module Admin
    class StoresController < Admin::BaseController
      inherit_resources
      actions :edit, :update

      def edit
        resource.build_address if resource.address.blank?
        edit!
      end

      def update
        update! { edit_admin_store_path }
      end

      protected

      def resource
        @store ||= current_store
      end
    end
  end
end