module Imentore
  class ImagePresenter
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(image)
      @image = image
      # binding.pry
    end

    def to_json
      {
        "name" => @image.picture_identifier,
        "size" => @image.picture.size,
        "url" => @image.picture.url,
        "thumbnail_url" => @image.picture.url(:super_thumb),
        "delete_url" => admin_product_variant_image_path(@image.imageable.product, @image.imageable, @image),
        "delete_type" => "delete"
      }
    end
  end
end
