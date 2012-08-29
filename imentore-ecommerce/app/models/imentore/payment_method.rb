require 'enumerate_it'
module Imentore

  class PaymentMethod < ActiveRecord::Base
    include EnumerateIt

    belongs_to :store
    serialize :options, Hash

    associate_values :handle, associate = [:pagamento_digital, :moip, :cielo, :moip, :pag_seguro]

    scope :active, where(active: true)

    validates :name, presence: true
    # validate :validate_provider

    # def validate_provider
      # errors.add(:handle, :invalid) if handle.blank? || provider.valid?
    # end

    def prepare(order = nil)
      provider
      provider.checkout(order)
    end

    def provider
      provider_class = "Imentore::PaymentMethod::#{handle.classify}".constantize
      @provider ||= provider_class.new(options)
    end
  end
end
