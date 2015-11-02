module Imentore
  module Admin

    class ImagesController < BaseController
      inherit_resources
      belongs_to :variant, parent_class: Imentore::ProductVariant
      skip_before_action :verify_authenticity_token, :if => Proc.new {|c| c.request.format == 'application/json'}
      respond_to :json, only: [:create, :index, :destroy, :new]
      respond_to :js, only: [:index, :destroy]

      def index
        # respond_with(files: collection.map {|image| Imentore::ImagePresenter.new(image).to_json})
        index!
      end

      def create
        create! do |success, failure|
          success.json {
            render json:{files: [Imentore::ImagePresenter.new(@image).to_json]}, status: :created 
          }
        end
      end

      def image_params
        params.require(:image).permit(:picture)
      end

      def destroy
        destroy! do |format|
          format.html { redirect_to admin_product_variant_images_path(@variant.product, @variant) }
          format.js { @images = collection }
        end
      end
    
    end
  end
end