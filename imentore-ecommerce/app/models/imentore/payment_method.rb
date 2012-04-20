module Imentore
  class PaymentMethod < ActiveRecord::Base
    belongs_to :store
    serialize :options, Hash

    def provider
      provider_class = "Imentore::PaymentMethod::#{handle.classify}".constantize
      @provider ||= provider_class.new(options)
    end
  end
end
