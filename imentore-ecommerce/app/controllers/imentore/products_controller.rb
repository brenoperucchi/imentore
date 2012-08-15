module Imentore
  class ProductsController < BaseController
    inherit_resources
    actions :show, :handle

    def handle
      product = current_store.products.find_by_handle(params[:handle])
      @product = ProductDrop.new(product)
      @variants = product.variants.map { |variant| ProductVariantDrop.new(variant) }
      @images = product.all_images.map { |image| ImageDrop.new(image)}
      render :show
    end

    def show
      product = current_store.products.find_by_handle(params[:handle])
      @product = ProductDrop.new(Imentore::Product.find(params[:id]))
      @variants = product.variants.map { |variant| ProductVariantDrop.new(variant) }
      @images = product.all_images.map { |image| ImageDrop.new(image)}
    end

  end
end
