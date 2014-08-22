module Imentore
  class ProductDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @product.send(method)
    end

    def initialize(product)
      @product = product
    end

    def name
      @product.name
    end

    def brand_name
      @product.product_brand.name
    end

    def id
      @product.id
    end

    def url
      product_handle_path(@product.handle)
    end

    def price
      number_with_price(@product.variants.first.price)
    end
   
    def price_deal
      number_with_price(@product.variants.first.price_deal)
    end

    def product_code
      "XYZ"
    end

    def description
      @product.description
    end

    def variants
      @product.variants.collect {|variant| ObjectDrop.new(variant)}
    end

    def image
      return nil if @product.variants.first.images.blank?
      @product.variants.first.images.first.picture.url(:small_fit)
    end

    def variant_id
      @product.variants.first.id
    end

    def stock_available?
      attr = @product.stock_available? ? "available" : "unavailable"
      I18n.t(attr)
    end

    def variant_deal?
      @variant = @product.variants.first
      !@variant.price_deal.nil? and @variant.price_deal > 0 
    end


  end
end