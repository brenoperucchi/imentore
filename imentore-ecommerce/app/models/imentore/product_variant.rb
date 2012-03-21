module Imentore
  class ProductVariant < ActiveRecord::Base
    validates :price, :quantity, :product_id, presence: true

    has_many    :options, class_name: "::Imentore::OptionValue"
    belongs_to  :product
  end
end
