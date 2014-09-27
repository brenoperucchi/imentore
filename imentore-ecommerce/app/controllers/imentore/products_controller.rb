module Imentore
  class ProductsController < BaseController
    inherit_resources
    actions :show, :handle

    def handle
      product = current_store.products.active.find_by_handle(params[:handle])
      @product = ProductDrop.new(product)
      @variants = product.variants.map { |variant| ProductVariantDrop.new(variant) }
      @images = product.all_images.map { |image| ImageDrop.new(image)}
      render :show
    end

    def show
      product = current_store.products.active.find_by_handle(params[:handle])
      @product = ProductDrop.new(Imentore::Product.find(params[:id]))
      @variants = product.variants.map { |variant| ProductVariantDrop.new(variant) }
      @images = product.all_images.map { |image| ImageDrop.new(image)}
    end

    def search
      @product_search = Imentore::ProductSearchDrop.new(params[:name]) if params[:name].present?
      @products = current_store.products.active.product_search(params[:name]).map {|p| Imentore::ProductDrop.new(p)}
      @products ||= []
    end

  end
end
