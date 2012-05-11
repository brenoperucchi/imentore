module Imentore
  class ProductVariant < ActiveRecord::Base
    has_many    :options, class_name: "::Imentore::OptionValue"
    has_many    :images, as: :imageable
    belongs_to  :product

    validates :price, :quantity, presence: true
  end
end
