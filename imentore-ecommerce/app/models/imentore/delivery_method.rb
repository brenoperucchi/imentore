module Imentore
  class DeliveryMethod < ActiveRecord::Base
    belongs_to :store
  end
end
