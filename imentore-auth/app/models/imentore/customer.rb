module Imentore
  class Customer < ActiveRecord::Base
    include Personhood

    belongs_to  :store
    has_one     :user,       as: 'userable', dependent: :destroy
    has_many    :addresses,  as: 'addressable', dependent: :destroy

    # validates :department, presence: true
    accepts_nested_attributes_for :user, :addresses

    def address
      addresses.first
    end

  end
end