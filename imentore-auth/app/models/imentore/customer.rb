module Imentore
  class Customer < ActiveRecord::Base
    include Personhood

    belongs_to  :store
    has_one     :user,       as: 'userable', dependent: :destroy
    has_many    :addresses,  as: 'addressable', dependent: :destroy

    # validates :department, presence: true
    validates_format_of :name, :with => /[\w]+([\s]+[\w]+){1}+/, message: I18n.t(:full_name_required, scope: [:errors, :messages_custom])
    validates :gender, presence: true
    accepts_nested_attributes_for :user, :addresses

    def address
      addresses.first
    end

  end
end