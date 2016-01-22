module AssetHelper
  def asset_thumbnail_url(asset)
    content_type = asset.content_type
    if not content_type.nil? and content_type.include?('image') and not content_type.include?('svg')
      asset.file.try(:url, :super_thumb)
    else
      icon_for(asset.file_identifier, size: '32px')
    end
  end

  def icon_for(filename, options={})
    name = filename.match(/[.](\w{1,6})\Z/) ? filename.match(/[.](\w{1,6})\Z/)[1] : "_blank"
    size = options[:size] ? options[:size] : "16px" 
    name = "/images/admin/file_icons/#{size}/#{name}.png"
    default = "/images/admin/file_icons/#{size}/_blank.png"
    name = File.exist?("#{Rails.root}/public#{name}") ? name : default
  end
end