module Imentore
  class CategoriesController < BaseController

    def index
      categories = params[:categories].split('/')
      @categories_root = Imentore::CategoryDrop.new(current_store.categories.find_by_handle(categories.first))
      categories.each do |cat|
        aux = current_store.categories.find_by_handle(cat)
        @category = (aux ? aux : nil)
      end
      @products = @category ? @category.products.active.order(sort_column).map { |product| Imentore::ProductDrop.new(product) } : []
      @ancestors = @category ? (@category.ancestors.map { |category| Imentore::CategoryDrop.new(category) } ) : []
      @childrens = @category ? (@category.children.map { |category| Imentore::CategoryDrop.new(category) } ) : []
      @category = Imentore::CategoryDrop.new(@category)
    end

    private
    
    def sort_column
      case params[:sort]
      when nil
        'id'
      when "recent"
        "created_at desc"
      when "name_a_z"
        "name asc"
      when "name_z_a"
        "name desc"
      when "price_low"
        "name desc"
      end
    end
    
  end
end
