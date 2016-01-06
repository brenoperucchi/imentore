require 'i18n'
  
class FormTag < Liquid::Block
  Syntax     = /(#{Liquid::QuotedFragment})\s*(by\s*(\d+))?/
  def initialize(tag_name, markup, tokens)
     @param_name = Liquid::Expression.parse(markup).name.gsub("form_", "")
     super
  end

  def form_nested(params, index, object, html_name)
    attribute = index.gsub("_attributes", "")
    object = object.send(attribute)
    params[index].each do |index, key|
      html_name = html_name << "[#{index}]"
      element = @doc.at("input[@name='#{html_name}']")
      form_nested(params[index], index, object, html_name) if index.include?("attributes")
      form_error(object, index, element)
    end
  end

  def form_error(object, index, element)
    if object.respond_to?(index) and object.errors[index].any? and not element.nil?
      klass = element.get_attribute(:class)
      element.set_attribute(:class, "error #{klass}")
    end
  end

  def render(context)
    params = context.registers[:controller].env["rack.request.form_hash"]
    unless params.nil?
      @object = context.registers[:action_view].assigns[@param_name]
      @doc = Hpricot(super)  # calling `super` returns the content of the block
      params[@param_name].each do |index, key| 
        if params["_method"].downcase == "post"
          html_name = "#{@param_name}[#{index}]"
          unless @object.valid?
            if index.include?("attributes")
              form_nested(params[@param_name], index, @object, html_name)
            else 
              element = @doc.at("input[@name='#{html_name}']")
              form_error(@object, index, element)
            end
          end
          @doc.search("input[@name='#{@param_name}[#{index}]']").each do |element|
            element.set_attribute(:value, key) unless element.get_attribute(:type) == "radio"
          end
        else
          next
        end
      end
      @doc
    else  
      super
    end
  end
end

Liquid::Template.register_tag('form', FormTag)