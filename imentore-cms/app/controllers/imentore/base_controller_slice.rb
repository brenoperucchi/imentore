require 'resolver'

Imentore::BaseController.class_eval do
  before_action :prepend_theme_path

  layout :theme_layout

  protected

  def prepend_theme_path
    if current_store
      prepend_view_path ::SqlTemplate::Resolver.instance_for_store(current_store, request)
    end
  end

  def theme_layout
    if current_store && current_store.theme.default_layout
      current_store.theme.default_layout
    elsif current_store
      'public'
    elsif current_store.nil?
      'site'
    end
  end

  private
  def _process_options(options)
    status, content_type, location = options.values_at(:status, :content_type, :location)
    self.status = status if status
    self.content_type = content_type if content_type
    self.headers["Location"] = url_for(location) if location
    return if options.key?(:text) || options.key?(:inline)

    template_id = view_paths.find(options[:template], options[:prefixes]) rescue nil

    if template_id
      template_id = template_id.identifier.split("-").first
      template = Imentore::Template.find(template_id)
      if template && template.layout.present?
        options[:layout] = "layouts/#{template.layout.path}"
      end
    end
  end
end

