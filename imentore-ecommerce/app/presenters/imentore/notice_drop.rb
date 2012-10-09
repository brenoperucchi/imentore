module Imentore
  class NoticeDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @object.send(method)
    end

    def initialize(notice)
      @notice = notice
    end

    def name
      @notice.name
    end

    def id
      @notice.id
    end

    def url
      notices_path(@notice.handle)
    end

    def created_at
      @notice.created_at.strftime('%d/%m/%Y')
    end

    def body
      @notice.body
    end

  end
end