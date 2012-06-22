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

  # def _render_template(options = {})
  #   binding.pry
  #   options[:layout] = lookup_context.view_paths.paths.first.the_template.layout if lookup_context.view_paths.paths.first.the_template
  #   super
  # end
end
