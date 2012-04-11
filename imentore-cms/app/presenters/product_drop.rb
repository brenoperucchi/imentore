class ProductDrop < Liquid::Drop
  include Imentore::Core::Engine.routes.url_helpers

  # def before_method(method)
  #   binding.pry
  #  end

  def initialize(product)
    # binding.pry
    @product = product
  end

  def name
    # binding.pry
    @product["name"]
  end

  def id
    @product.id
  end

  def url
    product_path(@product)
    # binding.pry
  end

  def price
    15
  end

  def product_code
    XYZ
  end

  # def to_liquid
  # end

end