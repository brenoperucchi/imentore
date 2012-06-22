module Imentore
  class CategoryPresenter

    def initialize(categories, product = nil)
      @categories = categories
      @product = product
    end

    def to_json
      ret = @categories.roots.map do |cat|
        {
          title: cat.name,
          key: cat.id,
          icon: false,
          expand: true,
          select: @product.category_ids.include?(cat.id),
          children: categories_children_json(cat.children)
        }
      end
    end

    def categories_children_json(childrens)
      ret = childrens.map do |cat|
              {
                title: cat.name,
                key: cat.id,
                icon: false,
                expand: true,
                select: @product.category_ids.include?(cat.id),
                children: categories_children_json(cat.children)
              }
            end
    end

  end
end