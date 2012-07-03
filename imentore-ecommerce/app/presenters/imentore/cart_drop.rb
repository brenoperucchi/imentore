module Imentore
  class CartDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @cart.send(method)
    end

    def initialize(cart)
      @cart = cart
    end

    def items
      @items = @cart.items.map { |item| CartItemDrop.new(item) }
    end

    def delivery_methods
      @delivery_methods = @context.registers[:current_store].delivery_methods.active.map { |object| ObjectDrop.new(object) }
    end
    
  end
end