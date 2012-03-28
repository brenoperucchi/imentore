module Imentore
  class Cart < ActiveRecord::Base
    serialize :items, Array

    def empty?
      items.empty?
    end
  end
end
