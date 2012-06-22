module Imentore
  class Category < ActiveRecord::Base
    has_ancestry

    has_many :categories_products
    has_many :products, :through => :categories_products, :source => :product

  end
end

