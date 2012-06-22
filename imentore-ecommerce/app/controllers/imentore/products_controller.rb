module Imentore
  class ProductsController < BaseController
    inherit_resources
    actions :show

    def show
      @product = ProductDrop.new(Imentore::Product.find(params[:id]))
      @variants = Imentore::Product.find(params[:id]).variants.map { |variant| ProductVariantDrop.new(variant) }
      @images = Imentore::Product.find(params[:id]).all_images.map { |image| ImageDrop.new(image)}
    end

  end
end
