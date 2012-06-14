module Imentore
  class DeliveryMethod::Custom < DeliveryMethod::Base

    attr_accessor :message_success, :message_error

    def self.name
      "Custom"
    end

    def initialize(options = {})
      @options = options
    end

  end
end
