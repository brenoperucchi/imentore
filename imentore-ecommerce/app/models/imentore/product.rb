module Imentore
  class Product < ActiveRecord::Base
    validates :name, :description, :permalink, presence: true

    has_many    :options, class_name: "::Imentore::OptionType"
    belongs_to  :store
  end
end
