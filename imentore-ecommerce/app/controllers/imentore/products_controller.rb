module Imentore
  class ProductsController < BaseController
    respond_to :html, :js, :json
    include SqlTemplate::ResolverMethods

    def render_template
      product = current_store.products.active.find_by_handle(params[:handle])
      @product = ProductDrop.new(product)
      @variants = product.variants.map { |variant| ProductVariantDrop.new(variant) }
      @images = product.all_images.map { |image| ImageDrop.new(image)}
      if params[:template]
        template_liquid = render_to_controller(params[:template])
        respond_to do |format|
          format.html { render :inline => template_liquid }
          format.json do 
            render :json => {response: template_liquid}, status: 200
          end
        end
      end
    end

    def handle
      product = current_store.products.active.find_by_handle(params[:handle])
      @product = ProductDrop.new(product)
      respond_to do |format|
        if not product.nil? and not product.try(:variants).nil?
          @variants = product.variants.map { |variant| ProductVariantDrop.new(variant) }
          @images = product.all_images.map { |image| ImageDrop.new(image)}
          @content_for_footer = render_to_controller("imentore/products/show", :header_view)
          format.html { render :show }
        else
          # @content_for_footer = render_to_string(template:(render_template_controller("imentore/products/show", :header_view)), layout:false)
          format.html { render template: "_error_page" }
        end
      end
    end

    def show
      product = current_store.products.active.find_by_handle(params[:handle])
      @product = ProductDrop.new(Imentore::Product.find_by_id(params[:id]))
      respond_to do |format|
        if not product.nil? and not product.try(:variants).nil?
          @variants = @product.variants.map { |variant| ProductVariantDrop.new(variant) }
          @images = @product.all_images.map { |image| ImageDrop.new(image)}
          format.html { }
          format.js 
        else
          format.html { render template: "_error_page" }
        end
      end
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