module Imentore
  class ProductSearchDrop < Liquid::Drop

    def initialize(object)
      @object = object
    end

    def name
      @object
    end

  end
end