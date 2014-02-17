module Imentore
  class NoticeDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers
    include ActionView::Helpers::TextHelper
    include ApplicationHelper

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

    def body_strip
      breaking_wrap_wrap(strip_tags(@notice.body),60)[0..90]+ "...." if breaking_wrap_wrap(strip_tags(@notice.body),60).length > 90
    end

  end
end