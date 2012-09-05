module LiquidFilter
  include ActionView::Context
  # include ActionView::Helpers::URLHelper
  # include ActionDispatch::Routing::Mapper
  include Imentore::Core::Engine.routes.url_helpers

  def asset_url(name)
    begin
      @context.registers[:current_store].theme.assets.find_by_file(name).file_url
    rescue StandardError
      "File Not Found: #{name.to_s}"
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
    @product = Imentore::Product.find_by_id(product.id)
    @product.variants.first.images.first.picture.url(size.to_sym).to_s
  end

  def image_url(size,obj)
    obj.image(size.to_s)
  end

  def variant_options_values(variant)
      names = variant.options.collect{|option| ["#{option.option_type.name}: #{option.value}"]}
      names.join(' - ')
  end

  def form_token(token)
    SecureRandom.base64(32)
  end

  def theme_include(name)
    begin
      url = @context.registers[:current_store].theme.assets.find_by_file(name).file_url
      if name.include?(".js",)
        "#{content_tag("script", "", { "type" => "text/javascript", "src" => url })}\n"
      elsif name.include?(".css")
        "#{content_tag('link', "", {'rel'=>'Stylesheet', 'media'=>'screen', 'type'=> 'text/css', 'href'=>url})}\n"
      end
    rescue StandardError
      "File Not Found: #{name.to_s}"
    end
  end

end