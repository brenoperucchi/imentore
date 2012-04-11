module Imentore

  class ProductsController < BaseController
    inherit_resources
    actions :show

    def show
      @product = ProductDrop.new(Imentore::Product.find(params[:id]))
      @variants = Imentore::Product.find(params[:id]).variants.map { |variant| ProductVariantDrop.new(variant) }
      # binding.pry
    end

  end
end
