module Imentore
  require 'carrierwave/processing/mime_types'
  class AssetPresenter
    include Imentore::Core::Engine.routes.url_helpers
    include CarrierWave::MimeTypes

    def initialize(asset)
      @asset = asset
    end

    def to_json
      {
        "name" => @asset.file_identifier,
        "size" => @asset.file.size,
        "url" => @asset.file.url,
        "thumbnail_url" => thumbnail_url(@asset),
        "delete_url" => admin_theme_asset_path(@asset.theme, @asset),
        "delete_type" => "delete"
      }
    end

    protected

    def thumbnail_url(asset)
      if asset.file.set_content_type(asset).include?('image')
        asset.file.try(:url, :super_thumb)
      else
        icon_for(asset.file_identifier, size: '48px')
      end
    end

    def icon_for(filename, options={})
      ext = filename.match(/[.](\w{1,6})\Z/)[1]
      size = "#{options[:size]}/" if options[:size]
      "/images/admin/file_icons/#{size ||=""}#{ext}.png"
    end

  end
end
