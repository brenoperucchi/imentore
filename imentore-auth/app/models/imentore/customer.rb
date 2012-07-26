module Imentore
  class Customer < ActiveRecord::Base
    include Personhood

    belongs_to  :store
    has_one     :user,       as: 'userable'
    has_many    :addresses,  as: 'addressable'

    # validates :department, presence: true
    accepts_nested_attributes_for :user, :addresses

    def address
      addresses.first
    end

    def owner?
      department == "owner"
    end

  end
end