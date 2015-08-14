module Imentore
  class CategoriesController < BaseController

    def index
      categories = params[:categories].split('/')
      # @category = categories.each do |cat|
      #   aux = current_store.categories.find_by_handle(cat)
      #   aux ? aux : nil
      # end
      @category = current_store.categories.find_by_handle(categories.last)
      @products_model = @category.products.active.order(sort_column)
      @products = @category ? @products_model.map { |product| Imentore::ProductDrop.new(product) } : []
      @ancestors = @category ? (@category.ancestors.map { |category| Imentore::CategoryDrop.new(category) } ) : []
      @childrens = @category ? (@category.children.map { |category| Imentore::CategoryDrop.new(category) } ) : []
      @category = Imentore::CategoryDrop.new(@category)
    end
    
  end
end