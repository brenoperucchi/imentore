module LiquidFilter
  include ActionView::Context
  include ActionView::Helpers::FormTagHelper 
  include ActionView::Helpers::AssetTagHelper
  include Imentore::Core::Engine.routes.url_helpers
  include ActionDispatch::Routing::Mapper::Base

  def asset_source(name, directories="")
    begin
      directories = directories.split('/').reject { |c| c.empty? }
      @folder = @context.registers[:current_store].theme.folders.find_by_name(directories.first)
      unless directories.empty?
        directories[1..-1].each {|dir| @folder = @folder.children.find_by_name(dir)}
      end
      if @folder and not directories.blank?
        @folder.assets.find_by_file(name).try(:file_url) || "/#{directories.join('/')}/#{name}"
      else
        @context.registers[:current_store].theme.assets.find_by_file(name).file_url || "/#{directories.join('/')}/#{name}"
      end
    rescue StandardError
      "/#{directories.join('/')}/#{name}"
    end
  end

  def product_url(product)
    content_tag(:a, product.name, :href=>product.url)
  end

  def product_image_link_to(product)
    content_tag(:a, :href=>product.url) do
      concat(tag(:img, :src => product.variants.first.images.first.picture.url(:small).to_s ))
    end
  end

  def product_image_url(product, size)
    size = nil if size == "original"
    product = Imentore::Product.find_by_id(product.id)
    product.variants.map{|v| v.images.map{|i| i.picture.url(size.try(:to_sym)).to_s}.try(:first)}.try(:compact).try(:first)
  end

  def image_source(obj, size)
    size = nil if size == "original"
    obj.image(size)
  end

  def variant_options_values(variant)
      names = variant.options.collect{|option| ["#{option.option_type.name}: #{option.value}"]}
      names.join(' - ')
  end

  def form_token(token)
    SecureRandom.base64(32)
  end

  def imentore_asset_url(name)
    javascript_include_tag "/assets/#{name}"
  end

  # def theme_include(name)
  #   begin
  #     url = @context.registers[:current_store].theme.assets.find_by_file(name).file_url
  #     if name.include?(".js",)
  #       "#{content_tag("script", "", { "type" => "text/javascript", "src" => url })}\n"
  #     elsif name.include?(".css")
  #       "#{content_tag('link', "", {'rel'=>'Stylesheet', 'media'=>'screen', 'type'=> 'text/css', 'href'=>url})}\n"
  #     end
  #   rescue StandardError
  #     "File Not Found: #{name.to_s}"
  #   end
  # end

end