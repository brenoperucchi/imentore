module Imentore
  class ProductVariant < ActiveRecord::Base
    has_many    :options, class_name: "::Imentore::OptionValue"
    has_many    :images, as: :imageable
    belongs_to  :product

    accepts_nested_attributes_for :options
    validates :price, :quantity, presence: true

    def options_name
      options.collect{|option| option.option_type.name + ":" + option.value}.join(' / ')
    end

  end
end
