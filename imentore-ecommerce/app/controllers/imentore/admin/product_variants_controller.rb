module Imentore
  module Admin
    class ProductVariantsController < BaseController
      inherit_resources
      defaults :resource_class => Imentore::ProductVariant, :collection_name => 'variants', :instance_name => 'variant'
      belongs_to :product, parent_class: Imentore::Product
      def update
        update! do |success, failure|
          success.html { redirect_to admin_product_variants_path(@product) }
          failure.html { render :index }
        end
      end

      def new
        @variant = build_resource
        @product.options.each do |option_type|
          @variant.options.build(option_type: option_type, product_variant: @variant)
        end
      end

      def create
        @product = current_store.products.find(params[:product_id])
        @variant = @product.variants.new(params[:variant])
        @variant.options.delete_all
        @variant.transaction do
          @variant.save
          params[:variant][:options_attributes].each do |attribute|
            # binding.pry
            @variant.options.build(product_variant: @variant, option_type_id: attribute[1]['option_type_id'], value: attribute[1]['value'])
          end
        end
        if @variant.save
          redirect_to admin_product_variants_path(@product)
        else
          render :index
        end
        # create! do |success, failure|
        # # binding.pry
        #   success.html { redirect_to admin_product_variants_path(@product) }
        #   failure.html {

        #     @product = Imentore::Product.find(params[:product_id])
        #     # @product.options.each do |option_type|
        #       # @variant.options.build(option_type: option_type, product_variant: @variant)
        #     # end
        #     render :new
        #   }
        # end
      end

      # protected

      # def begin_of_association_chain
      #   current_store
      # end
    end
  end
end
