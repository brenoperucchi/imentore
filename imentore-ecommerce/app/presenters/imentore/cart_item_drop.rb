module Imentore
  class CartItemDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @item.send(method)
    end

    def initialize(item)
      @item = item
    end

    def image(size = "small")
      @image = @item.variant.images.first.picture.url(size)
    end

    def url
      @url = product_path(@item.product)
    end

    def variant
      @variant = Imentore::ProductVariantDrop.new(@item.variant)
    end

    def product
      @product = Imentore::ProductDrop.new(@item.product)
    end

  end
end