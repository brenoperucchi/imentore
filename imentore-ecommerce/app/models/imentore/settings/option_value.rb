module Imentore
  class OptionValue < ActiveRecord::Base
    belongs_to  :option_type

    validates :option_type_id, :product_variant_id, :value, presence: true
  end
end
