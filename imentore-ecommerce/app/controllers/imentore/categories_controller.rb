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
      case params[:order]
      when nil
        'id'
      when "created_at"
        "created_at desc"
      end
      # @products.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    # def sort_direction
    #   %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    # end

  end
end
