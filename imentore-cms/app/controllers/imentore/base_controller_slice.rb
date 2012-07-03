require 'resolver'

Imentore::BaseController.class_eval do
  before_filter :prepend_theme_path

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
     else
      'public'
    end

  end

  private
  def _process_options(options)
    return if options.key?(:text) || options.key?(:inline)

    template_id = view_paths.find(options[:template], options[:prefixes]) rescue nil

    if template_id
      template_id = template_id.identifier.split("-").first
      template = Imentore::Template.find(template_id)

      if template && template.layout.present?
        options[:layout] = template.layout
      end
    end
  end

end

