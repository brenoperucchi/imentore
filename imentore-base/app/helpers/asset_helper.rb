module AssetHelper
  def asset_thumbnail_url(asset)
    if asset.content_type.include?('image')
      asset.file.try(:url, :super_thumb)
    else
      icon_for(asset.file_identifier, size: '32px')
    end
  end

  def icon_for(filename, options={})
    name = filename.match(/[.](\w{1,6})\Z/)[1]
    size = options[:size] ? options[:size] : "16px" 
    name = "/images/admin/file_icons/#{size}/#{name}.png"
    default = "/images/admin/file_icons/#{size}/_blank.png"
    name = File.exist?("#{Rails.root}/public#{name}") ? name : default
    return name
    # size = "#{options[:size]}/" if options[:size]
    # "/images/admin/file_icons/#{size ||=""}#{ext}.png"
  end

end