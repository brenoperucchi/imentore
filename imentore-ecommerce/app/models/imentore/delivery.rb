module Imentore
  class Delivery < ActiveRecord::Base
    belongs_to :delivery_method
  end
end
