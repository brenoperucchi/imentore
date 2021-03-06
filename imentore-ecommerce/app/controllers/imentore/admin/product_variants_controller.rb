module Imentore
  module Admin
    class ProductVariantsController < BaseController
      inherit_resources
      defaults :resource_class => Imentore::ProductVariant, :collection_name => 'variants', :instance_name => 'variant'
      belongs_to :product, parent_class: Imentore::Product
      respond_to :js, only: [:edit, :new]

      def requires
        @variant_update = @variant
        @variant = resource_class.new
        @product = parent
        @product.options.each { |option_type| @variant.options.build(option_type: option_type, product_variant: @variant) }
      end

      def update
        @product = current_store.products.find(params[:product_id])
        @variant = @product.variants.find(params[:id])
        @variant.attributes = variant_params
        update! do |success, failure|
          success.html {
            flash[:success] = "Atualizado com sucesso"
            redirect_to admin_product_variants_path(@product)
          }
          failure.html {
            requires
            # flash[:alert] = "Não foi atualizado!"
            render :index }
        end
      end

      def new
        requires
      end

      def index
        requires
        @variant_update = parent.variants.first
        index!
      end

      def destroy
        destroy! do 
          flash[:success] = "Removido com sucesso"
          admin_product_variants_path(@product) 
        end
      end

      def create
        @product = current_store.products.find(params[:product_id])
        @variant = @product.variants.new(variant_params)
        @variant.options.delete_all
        @variant.transaction do
          @variant.save
          params[:variant][:options_attributes].each do |attribute|
            @variant.options.build(product_variant: @variant, option_type_id: attribute[1]['option_type_id'], value: attribute[1]['value'])
          end
        end
        if @variant.save
          @variant_update = @product.variants.first
          flash[:success] = "Criado com sucesso"
          redirect_to admin_product_variants_path(@product)
        else
          @variant_update = nil
          # flash[:alert] = "Variant was not created."
          render "index"
        end
      end

      protected

      def variant_params
        params.require(:variant).permit(:sku, :quantity, :weight, :price, :price_deal, options_attributes:[:option_type_id, :value, :id])
      end

      # def begin_of_association_chain
      #   current_store
      # end
    end
  end
end
