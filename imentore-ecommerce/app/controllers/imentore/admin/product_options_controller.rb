module Imentore
  module Admin
    class ProductOptionsController < BaseController
      inherit_resources
      defaults resource_class: Imentore::OptionType, collection_name: 'options', instance_name: 'option'
      belongs_to :product, parent_class: Imentore::Product

      def create
        create! { admin_product_options_path(@product) }
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
