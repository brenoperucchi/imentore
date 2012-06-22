module Imentore
  module Admin
    class ProductBrandsController < BaseController
      inherit_resources
      actions :create, :new

      def create
        @product = current_store.products.find_by_id(params[:product_id])
        create! { edit_admin_product_path(@product) }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
