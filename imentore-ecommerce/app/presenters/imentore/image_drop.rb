module Imentore
  class ImageDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(image)
      @image = image
    end

    def id
      @image.id
    end

    def image(size = "small")
      @image.picture.url(size.to_sym)
    end

  end
end