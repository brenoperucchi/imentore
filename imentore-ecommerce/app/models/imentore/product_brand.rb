module Imentore
  class ProductBrand < ActiveRecord::Base

    validates :name, presence: true
  end
end