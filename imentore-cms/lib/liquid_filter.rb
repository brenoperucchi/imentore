module LiquidFilter
  def asset_url(name)
    # name + " " + @context.registers[:controller].current_store.name
    @context.registers[:current_store].assets.find_by_file(name).file_url
  end


  def theme_include(name)
    begin
      url = @context.registers[:controller].current_store.assets.find_by_file(name).file_url
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