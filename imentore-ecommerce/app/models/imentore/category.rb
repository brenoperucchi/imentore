module Imentore
  class Category < ActiveRecord::Base
    has_ancestry

    validates :handle, uniqueness: { scope: "store_id" }
    validates :handle, format: { with: /[a-z]+[-a-z]+[a-z]+/ }

    has_many :categories_products
    has_many :products, :through => :categories_products, :source => :product

    def handle=(param)
      param.nil? ? nil : write_attribute(:handle, param.to_underscore!)
    end

  end
end

