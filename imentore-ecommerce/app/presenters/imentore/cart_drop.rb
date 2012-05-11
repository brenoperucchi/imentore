module Imentore
  class CartDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @cart.send(method)
    end

    def initialize(cart)
      @cart = cart
    end

    # def items
    #   @cart.items
    # end

    # def amount
    #   @cart.amount
    # end

    # def method_missing(key, *args)
    #   self.respond_to?(key) ? send(key) : @cart.send(key)
    # end
  end
end