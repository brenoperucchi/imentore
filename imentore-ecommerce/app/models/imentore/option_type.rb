module Imentore
  class OptionType < ActiveRecord::Base
    validates :name, :handle, :product_id, presence: true
    validates :handle, uniqueness: { scope: "product_id" }
    validates :handle, format: { with: /[a-z]+[-a-z]+[a-z]+/ }
  end
end
