module Imentore
  class ObjectDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @object.send(method)
    end

    def initialize(object)
      @object = object
    end

  end
end