module Imentore
  class Invoice < ActiveRecord::Base
    belongs_to :payment_method
  end
end
