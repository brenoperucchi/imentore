module Imentore
  class CategoriesController < BaseController

    def index
      categories = params[:categories].split('/')
      categories.each do |cat|
        aux = current_store.categories.find_by_handle(cat)
        @category = (aux ? aux : nil)
      end
      @products = @category ? @category.products.active : []
    end
  end
end
