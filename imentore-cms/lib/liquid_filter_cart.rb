module LiquidFilterCart
  include ActionView::Context
  # include ActionView::Helpers::URLHelper
  # include ActionDispatch::Routing::Mapper
  include ActionView::Helpers::FormTagHelper 
  include Imentore::Core::Engine.routes.url_helpers
  include ActionDispatch::Routing::Mapper::Base

  ## http://guides.rubyonrails.org/v3.2.21/action_controller_overview.html#default_url_options
  def default_url_options
    {:locale => I18n.locale}
  end

  def cart_delivery_methods(args)
    select_tag 'delivery_method', options_from_collection_for_select(@context.registers[:current_store].delivery_methods.active, "id", "name", :id => 'delivery_method'), :class => 'form-control'
  end

  def cart_remove_item(item, klass)
    content_tag(:a, href: cart_path(variant_id: item.variant.id, product_id: item.product.id), "data-method" => 'delete', class: 'klass') do 
      content_tag(:i, class: 'icon-trash.icon-white') do
        concat(' ' + I18n.t(:remove))
      end
    end
  end
  ## /TODO
end