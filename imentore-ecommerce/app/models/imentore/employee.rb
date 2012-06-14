module Imentore
  class Employee < ActiveRecord::Base
    include Personhood

    belongs_to  :store
    has_one     :user, as: 'userable'
    has_many    :addresses,  as: 'addressable'

    validates :department, presence: true

    def address
      addresses.first
    end

    accepts_nested_attributes_for :user

    def owner?
      department == "owner"
    end
  end
end