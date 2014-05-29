module Imentore
  class ProductVariant < ActiveRecord::Base
    has_many    :options, class_name: "::Imentore::OptionValue", dependent: :destroy
    has_many    :images, as: :imageable, dependent: :destroy 
    belongs_to  :product

    validates :price, :quantity, presence: true
    accepts_nested_attributes_for :options

    def options_name
      options.collect{|option| option.option_type.name + ":" + option.value}.join(' / ')
    end

  end
end
