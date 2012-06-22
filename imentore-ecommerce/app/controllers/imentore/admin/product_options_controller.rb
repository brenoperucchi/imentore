module Imentore
  module Admin
    class ProductOptionsController < BaseController
      inherit_resources
      defaults resource_class: Imentore::OptionType, collection_name: 'options', instance_name: 'option'
      actions :index, :create, :destroy, :edit, :update
      belongs_to :product, parent_class: Imentore::Product

      after_filter :create_option_types, only: [:create]
      after_filter :destroy_option_types, only: [:destroy]

      def create_option_types
        @option.create_option_types(@product)
      end

      def destroy_option_types
        @option.destroy_option_types(@product, @option)
      end

      def create
        create! do |success, failure|
          success.html { redirect_to admin_product_options_path(@product) }
          failure.html do
            @options = Imentore::Product.find(params[:product_id]).options
            render :index
          end
        end
      end

      def destroy
        destroy! { admin_product_options_path(@product) }
      end

      def update
        update! { admin_product_options_path(@product) }
      end
    end
  end
end
