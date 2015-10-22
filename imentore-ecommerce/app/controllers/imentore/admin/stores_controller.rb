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

      def store_params
        params.require(:store).permit(:name, :email, :brand, :irs_id, address_attributes:[:name, :street, :complement, :city, :country, :state, :zip_code, :phone])
      end

      def resource
        @store ||= current_store
      end
    end
  end
end