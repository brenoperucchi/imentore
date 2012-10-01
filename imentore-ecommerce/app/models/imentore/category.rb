module Imentore
  class Category < ActiveRecord::Base
    has_ancestry :cache_depth =>true

    validates :handle, uniqueness: { scope: "store_id" }
    validates :name, presence: true
    validates :handle, format: { with: /^[-A-Za-z\d_]+$/ }

    has_many :categories_products
    has_many :products, :through => :categories_products, :source => :product

    def handle=(param)
      return nil if name.blank?
      param.blank? ? write_attribute(:handle, name.to_underscore!) : write_attribute(:handle, param.to_underscore!)
    end

  end
end