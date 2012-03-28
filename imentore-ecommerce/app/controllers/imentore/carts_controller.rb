module Imentore
  class CartsController < BaseController
    def show
      @cart = Cart.new
    end
  end
end
