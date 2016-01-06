module Imentore
  require 'carrierwave/processing/mime_types'
  class AssetPresenter
    include Imentore::Core::Engine.routes.url_helpers
    include AssetHelper
    include CarrierWave::MimeTypes

    def initialize(asset)
      @asset = asset
    end

    def to_json
      {
        "name" => @asset.file_identifier,
        "size" => @asset.file.size,
        "url" => @asset.file.url,
        "thumbnailUrl" => asset_thumbnail_url(@asset),
        "deleteUrl" => admin_theme_asset_folder_asset_path(@asset.theme, @asset.folder, @asset),
        "deleteType" => "delete"
      }
    end

    protected

  end
end