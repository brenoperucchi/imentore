module Imentore
  class CategoriesProduct < ActiveRecord::Base

    belongs_to :product
    belongs_to :category

  end
end
