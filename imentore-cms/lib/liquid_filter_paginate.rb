module LiquidFilterPaginate
  include ActionView::Context
  # include ActionView::Helpers::URLHelper
  # include ActionDispatch::Routing::Mapper
  # include ActionView::Helpers
  include ActionView::Helpers::FormTagHelper 
  include Imentore::Core::Engine.routes.url_helpers
  include ActionDispatch::Routing::Mapper::Base

  def option_select(selected, value, name)
    if selected != value
      "<option label='#{name}' id='#{name}' value='#{value}')/>"
    else
      "<option label='#{name}' id='#{name}' value='#{value}' selected='selected')/>"
    end
  end

  def select_selected(param, value)
    {'selected' => 'selected'} if param == value
  end

  def url_param(param)
    ## sort-by=[^&]+)
    @context.registers[:controller].params[param] 
  end

  def per_page(paginate, per_page)
    current_url = @context.registers[:controller].request.fullpath.gsub(/(per_page=)[0-9]+&?/, '')
    current_url = current_url.gsub(/(page=)[0-9]+&?/, '')
    current_url = current_url.slice(0..-2) if current_url.last == '?' || current_url.last == '&'
    current_url += "#{current_url.include?('?') ? '&' : '?'}per_page=#{per_page}"
  end

  def current_offset(paginate)
    (paginate['current_offset'] + 1).to_s
  end

  def items_page(paginate)
    paginate['items_page']
  end

  def default_pagination(paginate)
    html = []
    html << %(<li class="prev">#{link_to(paginate['previous']['title'], paginate['previous']['url'])}</li>) if paginate['previous']
    for part in paginate['parts']
      if part['is_link']
        html << %(<li>#{link_to(part['title'], part['url'])}</li>)
      elsif part['title'].to_i == paginate['current_page'].to_i
        # html << %(<li class="page active">#{part['title']}</li>)
        html << %(<li class="active">#{link_to(part['title'], '#')}</li>)
      else
        html << %(<li>#{part['title']}</li>)
     end
    end
    html << %(<li class="next">#{link_to(paginate['next']['title'], paginate['next']['url'])}</li>) if paginate['next']
    html.join(' ')
  end
  # def default_pagination(paginate)    
  #   html = []    
  #   html << %(<span class="prev">#{link_to(paginate['previous']['title'], paginate['previous']['url'])}</span>) if paginate['previous']

  #   for part in paginate['parts']

  #     if part['is_link']
  #       html << %(<span class="page">#{link_to(part['title'], part['url'])}</span>)        
  #     elsif part['title'].to_i == paginate['current_page'].to_i
  #       html << %(<span class="page current">#{part['title']}</span>)        
  #     else
  #       html << %(<span class="deco">#{part['title']}</span>)                
  #     end
      
  #   end

  #   html << %(<span class="next">#{link_to(paginate['next']['title'], paginate['next']['url'])}</span>) if paginate['next']
  #   html.join(' ')
  # end
end