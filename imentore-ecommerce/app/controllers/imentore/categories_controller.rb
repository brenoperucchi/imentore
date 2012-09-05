module Imentore
  class CategoriesController < BaseController

    def index
      categories = params[:categories].split('/')
      @categories_root = Imentore::CategoryDrop.new(current_store.categories.find_by_handle(categories.first))
      categories.each do |cat|
        aux = current_store.categories.find_by_handle(cat)
        @category = (aux ? aux : nil)
      end
      @products = @category ? @category.products.active.map { |product| Imentore::ProductDrop.new(product) } : []
      @ancestors = @category ? (@category.ancestors.map { |category| Imentore::CategoryDrop.new(category) } ) : []
      @childrens = @category ? (@category.children.map { |category| Imentore::CategoryDrop.new(category) } ) : []
      @category = Imentore::CategoryDrop.new(@category)
    end

  end
end
