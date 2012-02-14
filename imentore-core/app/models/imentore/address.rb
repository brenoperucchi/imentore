module Imentore
  class Address < ActiveRecord::Base
    attr_accessor :validate

    belongs_to :addressable, polymorphic: true

    validates :name, :street, :city, :state, :country, :zip_code, :phone,
      presence: true,
      if: :validate?

    def validate?
      validate == true
    end
  end
end