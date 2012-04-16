module Imentore
  class PaymentMethod < ActiveRecord::Base
    belongs_to :store
  end
end
