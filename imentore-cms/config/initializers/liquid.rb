Dir.glob(File.join(Rails.root, '/../imentore-cms/lib/liquid/*.rb')).each do |path|
require path
end

# http://www.royvandermeij.com/blog/2011/09/21/create-a-liquid-handler-for-rails-3-dot-1/
require 'liquid_filter'
require 'liquid_filter_cart'

# Liquid::Template.class_eval do
#   def register_filter(mod)
#     Strainer.global_filter(mod)
#   end
# end

class LiquidView
  def self.call(template)
    "LiquidView.new(self).render(#{template.source.inspect}, local_assigns)"
  end

  def initialize(view)
    @view = view
  end

  def render(template, local_assigns = {})
    @view.controller.headers["Content-Type"] ||= 'text/html; charset=utf-8'
    # @view.controller.headers["X-CSRF-Token"] ||= @view.controller.session['_csrf_token']
    assigns = @view.assigns

    if @view.content_for?(:layout)
      assigns["content_for_layout"] = @view.content_for(:layout)
      assigns["content_for_header"] = @view.content_for(:header)
      assigns["content_for_javascript"] = @view.content_for(:javascript) 
    end
    assigns["_csrf_token"] = @view.controller.session['_csrf_token']
    assigns["csrf_token"] = @view.form_authenticity_token
    assigns.merge!(local_assigns.stringify_keys)


    #Assigns Permanent
    store = @view.current_store
    assigns["user_signed?"] = @view.user_signed_in?
    assigns["store"] = @store = Imentore::StoreDrop.new(store)
    assigns["pages"] = store.pages.active.order('id desc').map { |page| Imentore::PageDrop.new(page) }
    assigns["notices"] = store.notices.active.order('id desc').map { |notice| Imentore::NoticeDrop.new(notice) }
    assigns["categories"] = store.categories.roots.order('name').map { |category| Imentore::CategoryDrop.new(category) }



    controller = @view.controller
    filters = if controller.respond_to?(:liquid_filters, true)
                controller.send(:liquid_filters)
              elsif controller.respond_to?(:master_helper_module)
                [controller.master_helper_module]
              else
                [controller._helpers]
              end
    # Liquid::Template.register_tag("paginate", Paginate)
    # liquid = Liquid::Template.parse(template)

    liquid = Liquid::Template.new
    t = liquid.parse(template)
    t.class.register_filter(LiquidFilter)
    t.class.register_filter(LiquidFilterCart)
    t.render(assigns.merge("current_cart" => Imentore::CartDrop.new(controller.current_cart)), :filters => filters,
      :registers => {current_store: @view.controller.current_store, :action_view => @view, :controller => @view.controller})
  end

  def compilable?
    false
  end
end

ActionView::Template.register_template_handler(:liquid, LiquidView)