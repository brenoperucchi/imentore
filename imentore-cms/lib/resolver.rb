module SqlTemplate
  class Resolver < ActionView::Resolver
    include Singleton

    protected

    def find_templates(name, prefix, partial, details)
      handler = ActionView::Template.handler_for_extension('erb')
      details = {
        format: Mime['html'],
        updated_at: Time.now,
        virtual_path: 'shared/not_found'
      }
      template_name = "#{prefix}/#{name}"
      sources = {
        "shared/not_found" => "shared <br> <%= render 'shared/partial' %> <br> not_found",
        "shared/partial" => "partial",
        "layouts/application" => "LAYOUT <br> <%= yield %>"
      }
      templates = []
      if sources.key?(template_name)
        templates << ActionView::Template.new(sources[template_name], template_name, handler, details)
      end
      templates
    end
  end
end