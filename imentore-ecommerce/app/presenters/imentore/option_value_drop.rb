module Imentore
  class OptionValueDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @option_value.send(method)
    end

    def initialize(option_value)
      @option_value = option_value
    end

    def id
      @option_value.id
    end

    def value
      number_with_price(@option_value.value)
    end

    def option_type
      @option_value.option_type
    end

    def option_type_id
      @option_value.option_type_id
    end

  end
end