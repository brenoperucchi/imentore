module Imentore
  class CategoryDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @object.send(method)
    end

    def initialize(category)
      @object = category
    end

    def name
      @object.name
    end

    def id
      @object.id
    end

    def url
      category_path(@object)
    end

    def products_count
      @object.products.size
    end

    def products
      @object.products.collect{|product| ProductDrop.new(product)}
    end

    def children
      children = @object.children.collect{|category| CategoryDrop.new(category)}
    end

    def ancestors
      @ancestors = @object.ancestors.collect{|ancestor| CategoryDrop.new(ancestor)}
    end
    
    def has_children?
      @object.has_children?
    end

    protected

    def category_path(category)
      categories_path(category.path.map{|x| x.handle}.join('/'))
    end
  end
end