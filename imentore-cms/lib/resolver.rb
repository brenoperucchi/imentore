module SqlTemplate
  class Resolver < ActionView::Resolver
    include Singleton

    attr_accessor :current_store, :request, :the_template

    def self.instance_for_store(store, request)
      # single-thread mode + unicorn = thread-safety
      instance.current_store = store
      instance.request = request
      instance
    end

    protected

    def find_templates(name, prefix, partial, details)
      templates     = []
      template_path = build_path(name, prefix, partial)
      template      = find_by_request_path unless template_path.include?("layouts/")
      template      ||= find_by_template_path(template_path)
      # binding.pry


      if template
        @the_template = template
        handler = ActionView::Template.handler_for_extension(template.handler)
        template_id = "#{current_store.theme.id}-#{template.path}"
        details = {
          format:       Mime['html'],
          # Resolvers now consider timestamps
          # https://github.com/rails/rails/commit/38d78f99d5
          # http://forums.pragprog.com/forums/191/topics/8666
          updated_at:   template.updated_at,
          virtual_path: template.path,
          _layout: template.layout
        }
        templates << ActionView::Template.new(template.body, template_id, handler, details)
        # http://stackoverflow.com/a/6358022
      end

      templates
    end

    private

    def find_by_request_path
      request.env['layout'] = false if request.env['layout'].nil?
      template = find_by_template_path(request.path_info)
      template = nil if not template.nil? and template.layout == "false" and request.env['layout'] == true
      request.env['layout'] = true
      return template
    end

    def find_by_template_path(path)
      current_store.theme.templates.find_by_path(path)
    end
  end
end

module Foo
  def render(*args, &block)
    binding.pry
    super
  end
  # alias_method_chain :render, :dblayout
  # def render_with_dblayout options = nil, extra_options = {}, &block
  #  if options.include? :layout
  #  else
  #    render_without_dblayout options, extra_options { yield }
  #  end
  # end
end

# ActionController::Base.send(:include, Foo)
