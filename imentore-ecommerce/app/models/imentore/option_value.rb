module Imentore
  class OptionValue < ActiveRecord::Base
    belongs_to  :option_type
    belongs_to :product_variant

    validates :option_type_id, :product_variant_id, presence: true
  end
end
