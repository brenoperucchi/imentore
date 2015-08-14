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
      if params[:name].present?
        redirect_to products_result_path(name: params[:name])
      else
        @products = []          
        render :result
      end
    end

    def result
      @product = Imentore::ProductSearchDrop.new(params[:name]) 
      @products_model = current_store.products.active.product_search(params[:name]).order(sort_column)
      @products = @products_model.map {|p| Imentore::ProductDrop.new(p)}
      @products ||= []          
    end

  end
end