module Imentore
  module Admin
    class ProductsController < BaseController
      inherit_resources
      actions :index, :new, :create, :edit, :update
      respond_to :json, only: :update

      def index
        index! do |index|
          index.html{@products = current_store.products.paginate(:page => params[:page]).order(sort_column + " " + sort_direction)}
          index.json{render json: Imentore::ProductsDatatable.new(view_context, current_store)}
        end
      end

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
        create! do |success, failure|
          success.html do
            default_option = @product.options.create(name: t(:default), handle: t(:default).to_underscore)
            variant = @product.variants.first
            variant.options.create(option_type: default_option, value: "default")
            redirect_to admin_products_path
          end
          failure.html do
            render :new
          end
        end
      end

      def update
        @product = current_store.products.find_by_id(params[:id])
        @product.attributes = params[:product]
        update! do |success, failure|
          success.html do
            @product.product_brand = current_store.product_brands.find_by_name(params[:product][:product_brand_name])
            @product_brand = @product.product_brand
            @product.save
            flash[:success] = t(:product_updated)
            redirect_to edit_admin_product_path(@product)
          end
          success.json do
            @product.category_ids = []
            @product.category_ids = params[:cat_ids]
            render :edit
          end
          failure.html do
            @product.product_brand = current_store.product_brands.find_by_name(params[:product][:product_brand_name])
            @product_brand = @product.product_brand
            render :update
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
