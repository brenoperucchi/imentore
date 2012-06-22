module Imentore
  class AssetPresenter
    include Imentore::Core::Engine.routes.url_helpers

    def initialize(asset)
      @asset = asset
    end

    def to_json
      {
        "name" => @asset.file_identifier,
        "size" => @asset.file.size,
        "url" => @asset.file.url,
        "thumbnail_url" => @asset.file.url(:super_thumb),
        "delete_url" => admin_theme_asset_path(@asset.theme, @asset),
        "delete_type" => "delete"
      }
    end
  end
end
