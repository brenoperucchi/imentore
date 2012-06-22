module Imentore
  module Admin
    class ProductsController < BaseController
      inherit_resources
      actions :index, :new, :create, :edit, :update
      respond_to :json, only: :update

      def new
        @product = build_resource
        @product.variants.build
        new!
      end

      def edit
        @product_brand = current_store.product_brands.build
        edit!
      end

      def create
        create! do
          default_option = @product.options.create(name: "Model", handle: "model")
          variant = @product.variants.first
          variant.options.create(option_type: default_option, value: "default")
          admin_products_path
        end
      end

      def update
        @product = current_store.products.find_by_id(params[:id])
        @product.attributes = params[:product]

        update! do |format|
          format.html{
            @product.product_brand = current_store.product_brands.find_by_name(params[:product][:product_brand_name])
            @product.save
            redirect_to edit_admin_product_path(@product)
          }
          format.json do
            @product.category_ids = []
            @product.category_ids = params[:cat_ids]
            render :edit
          end
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
