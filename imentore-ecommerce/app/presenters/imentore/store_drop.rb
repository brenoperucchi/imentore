module Imentore
  class StoreDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @object.send(method)
    end

    def initialize(store)
      @store = store
    end

    def name
      @store.name
    end

    def id
      @store.id
    end

    def email_contact
      @email_contact = @store.email_contact
    end

    def site
      @store.config.site
    end

  end
end