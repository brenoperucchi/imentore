module ApplicationHelper
  include ActionView::Helpers

  def theme_include(name, url)
    if name.include?(".js",)
      "#{content_tag("script", "", { "type" => "text/javascript", "src" => url })}\n"
    elsif name.include?(".css")
      "#{content_tag('link', "", {'rel'=>'Stylesheet', 'media'=>'screen', 'type'=> 'text/css', 'href'=>url})}\n"
    end
  end

end
