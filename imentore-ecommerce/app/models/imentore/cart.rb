module Imentore
  class Cart < ActiveRecord::Base
    serialize :items, Hash

    def empty?
      items.empty?
    end

    def add(product, variant, quantity)
      items[product] = { variant => quantity }
      save
    end
  end
end
