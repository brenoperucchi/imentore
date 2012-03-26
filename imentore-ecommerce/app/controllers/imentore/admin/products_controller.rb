module Imentore
  module Admin
    class ProductsController < BaseController
      inherit_resources
      actions :index, :new, :create

      def new
        @product = build_resource
        @product.variants.build
        new!
      end

      def create
        create! do
          default_option = @product.options.create(name: "Model", handle: "model")
          variant = @product.variants.first
          variant.options.create(option_type: default_option, value: "default")

          admin_products_path
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
