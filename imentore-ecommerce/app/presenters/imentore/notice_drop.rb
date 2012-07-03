module Imentore
  class NoticeDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

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
      notice_path(@notice.handle)
    end

    def created_at
      @notice.created_at.strftime('%d/%m/%Y')
    end

    def description
      @notice.description
    end

  end
end