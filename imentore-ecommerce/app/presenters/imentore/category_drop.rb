module Imentore
  class CategoryDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

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

    def children
      children = @category.children.collect{|category| CategoryDrop.new(category)}
    end

    protected

    def category_path(category)
      categories_path(category.path.map{|x| x.handle}.join('/'))
    end
  end
end