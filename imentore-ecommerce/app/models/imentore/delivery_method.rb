module Imentore
  class DeliveryMethod < ActiveRecord::Base
    belongs_to :store
    serialize :options, Hash

    scope :active, -> { where(active: true) }
    validates :name, presence: true

    def provider
      provider_class = "Imentore::DeliveryMethod::#{handle.classify}".constantize
      @provider ||= provider_class.new(options)
    end

  end
end
