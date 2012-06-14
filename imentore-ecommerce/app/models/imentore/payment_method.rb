module Imentore
  class PaymentMethod < ActiveRecord::Base
    belongs_to :store
    serialize :options, Hash

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
