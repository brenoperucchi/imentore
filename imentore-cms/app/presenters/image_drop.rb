class ImageDrop < Liquid::Drop
  include Imentore::Core::Engine.routes.url_helpers
  require 'pry'

  # def before_method(method)
  #   binding.pry
  #  end

  def initialize(image)
    # binding.pry
    @image = image
  end

  def id
    @image.id
  end

  def url(size = "small")
    @image.picture.url(size.to_sym)
  end

end