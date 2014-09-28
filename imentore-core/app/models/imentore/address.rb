module Imentore
  class Address < ActiveRecord::Base
    attr_accessor :validate

    belongs_to :addressable, polymorphic: true

    validates :name, :street, :complement, :city, :state, :country, :zip_code, :phone, presence: true#, if: :validate?

    def to_s
      "#{street}, #{city}, #{state}, #{zip_code}, #{country}"
    end

    def validate?
      validate == true
    end
  end
end