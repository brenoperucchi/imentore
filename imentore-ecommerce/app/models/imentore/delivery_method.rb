module Imentore
  class DeliveryMethod < ActiveRecord::Base
    belongs_to :store
    serialize :options, Hash
  end
end
