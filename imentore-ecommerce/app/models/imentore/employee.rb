module Imentore
  class Employee < ActiveRecord::Base
    include Personhood

    belongs_to  :store
    has_one     :user, as: 'userable'

    validates :department, presence: true

    accepts_nested_attributes_for :user
  end
end