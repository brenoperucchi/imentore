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
    size = nil if size == "original"
    @product = Imentore::Product.find_by_id(product.id)
    return if @product.variants.first.images.blank?
    @product.variants.first.images.first.picture.url(size.try(:to_sym)).to_s
  end

  def image_url(obj, size)
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

  def default_pagination(paginate)    
    html = []    
    html << %(<span class="prev">#{link_to(paginate['previous']['title'], paginate['previous']['url'])}</span>) if paginate['previous']

    for part in paginate['parts']

      if part['is_link']
        html << %(<span class="page">#{link_to(part['title'], part['url'])}</span>)        
      elsif part['title'].to_i == paginate['current_page'].to_i
        html << %(<span class="page current">#{part['title']}</span>)        
      else
        html << %(<span class="deco">#{part['title']}</span>)                
      end
      
    end

    html << %(<span class="next">#{link_to(paginate['next']['title'], paginate['next']['url'])}</span>) if paginate['next']
    html.join(' ')
  end

end