module Imentore
  class PageDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(page)
      @page = page
    end

    def name
      @page.name
    end

    def id
      @page.id
    end

    def url
      pages_path(@page.handle)
    end
  end
end