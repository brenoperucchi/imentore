module Imentore
  module Admin
    class ProductVariantsController < BaseController
      inherit_resources
      defaults :resource_class => Imentore::ProductVariant, :collection_name => 'variants', :instance_name => 'variant'
      belongs_to :product, parent_class: Imentore::Product

      def requires
        @variant_update = @variant
        @variant = resource_class.new
        @product = parent
        @product.options.each { |option_type| @variant.options.build(option_type: option_type, product_variant: @variant) }
      end

      def update
        update! do |success, failure|
          success.html {
            flash[:success] = "Atualizado com sucesso"
            redirect_to admin_product_variants_path(@product)
          }
          failure.html {
            requires
            flash[:alert] = "Nao possivel atualizar"
            redirect_to edit_admin_product_variant_path(@product, @variant_update)
          }
        end
      end

      def index
        requires
        @variant_update = parent.variants.first
        index!
      end

      def new
      end

      def create
        @product = current_store.products.find(params[:product_id])
        @variant = @product.variants.new(params[:variant])
        @variant.options.delete_all
        @variant.transaction do
          @variant.save
          params[:variant][:options_attributes].each do |attribute|
            @variant.options.build(product_variant: @variant, option_type_id: attribute[1]['option_type_id'], value: attribute[1]['value'])
          end
        end
        if @variant.save
          @variant_update = @product.variants.first
          flash[:success] = "Variant was successfully created."
          redirect_to admin_product_variants_path(@product)
        else
          @variant_update = @product.variants.first
          flash[:alert] = "Variant was not created."
          render :index
        end
      end

      protected

      # def begin_of_association_chain
      #   current_store
      # end
    end
  end
end
