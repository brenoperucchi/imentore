module Imentore
  class Invoice < ActiveRecord::Base
    attr_accessor :payment_method
  end
end
