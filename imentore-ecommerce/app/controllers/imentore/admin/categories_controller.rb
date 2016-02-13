module Imentore
  module Admin
    class CategoriesController < BaseController
      inherit_resources
      respond_to :json, only: [:index]
      respond_to :js, only: [:destroy, :edit]

      def index
        @category = begin_of_association_chain.categories.new
        index! do |format|
          format.json do
            @product = current_store.products.find_by_id(params[:product_id])
            render json: Imentore::CategoryPresenter.new(current_store.categories, @product).to_json
          end
        end
      end

      def new
        @category = build_resource

      end

      def edit
        # @category = begin_of_association_chain.categories.new
        @categories = collection
        edit!
      end

      def create
        respond_to do |wants|
          wants.html do
            @category = current_store.categories.new(category_params)
            @category.parent = current_store.categories.find_by_id(params[:category][:ancestry])
            if @category.save
              redirect_to admin_categories_path
            else
              @categories = collection
              render :index
            end
          end
        end
      end

      def collection
        @categories = begin_of_association_chain.categories.order('name')
      end

      def update
        update! { admin_categories_path }
      end

      def destroy
        destroy! do |format|
          format.html { admin_categories_path }
          format.js do
            @categories = collection
          end
        end
      end

      protected

      def category_params
        params.require(:category).permit(:name, :handle, :ancestry)
      end

      def begin_of_association_chain
        current_store
      end
    end
  end
end
