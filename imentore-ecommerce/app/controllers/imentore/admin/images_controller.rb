module Imentore
  module Admin
    class ImagesController < BaseController
      inherit_resources
      belongs_to :variant, parent_class: Imentore::ProductVariant
      # actions :index, :new, :create


      # def index


      # def new
      #   @product = build_resource
      #   @product.variants.build
      #   new!
      # end

      # def create
      #   create! do
      #     default_option = @product.options.create(name: "Model", handle: "model")
      #     variant = @product.variants.first
      #     variant.options.create(option_type: default_option, value: "default")

      #     admin_products_path
      #   end
      # end

      # protected

      # def begin_of_association_chain
      #   current_store
      # end
    end
  end
end
