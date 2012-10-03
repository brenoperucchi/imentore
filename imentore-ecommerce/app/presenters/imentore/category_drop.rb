module Imentore
  class CategoryDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @object.send(method)
    end

    def initialize(category)
      @category = category
    end

    def name
      @category.name
    end

    def id
      @category.id
    end

    def url
      category_path(@category)
    end

    def products_count
      @category.products.size
    end

    def products
      @category.products
    end

    def children
      children = @category.children.collect{|category| CategoryDrop.new(category)}
    end

    def ancestors
      @ancestors = @category.ancestors.collect{|ancestor| CategoryDrop.new(ancestor)}
    end

    protected

    def category_path(category)
      categories_path(category.path.map{|x| x.handle}.join('/'))
    end
  end
end