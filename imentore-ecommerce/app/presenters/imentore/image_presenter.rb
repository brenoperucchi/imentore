module Imentore
  class ImagePresenter
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(image)
      @image = image
    end

    def to_json
      {
        "name" => @image.picture_identifier,
        "size" => @image.picture.size,
        "url" => @image.picture.url,
        "thumbnailUrl" => @image.picture.url(:super_thumb),
        "deleteUrl" => admin_product_variant_image_path(@image.imageable.product, @image.imageable, @image),
        "deleteType" => "delete"
      }
    end
  end
end
