module Imentore
  class Invoice < ActiveRecord::Base
    belongs_to :payment_method

    def prepare
      payment_method.prepare
    end
  end
end
