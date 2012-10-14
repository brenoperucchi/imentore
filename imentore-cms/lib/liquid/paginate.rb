require 'will_paginate/array'
# Paginate a collection
#
# Usage:
#
# {% paginate contents.projects by 5 %}
#   {% for project in paginate.collection %}
#     {{ project.name }}
#   {% endfor %}
#  {% endpaginate %}
#
class Paginate < ::Liquid::Block
  Syntax = /(#{::Liquid::Expression}+)\s+by\s+([0-9]+)/

  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @collection_name = $1
      @per_page = $2.to_i
    else
      raise ::Liquid::SyntaxError.new("Syntax Error in 'paginate' - Valid syntax: paginate <collection> by <number>")
    end
    super
  end

  def render(context)
    context.stack do
      collection = context[@collection_name]
      params = context.registers[:controller].params.clone

      raise ::Liquid::ArgumentError.new("Cannot paginate array '#{@collection_name}'. Not found.") if collection.nil?

      pagination = collection.send(:paginate, {
        :include  => [:images, :master],
        :page       => params[:page],
        :per_page   => @per_page })
      
      context[@collection_name] = pagination  

      page_count, current_page = pagination.total_pages, pagination.current_page

      path = context.registers[:controller].request.path
      params.delete(:page) if params[:page]
      params.delete(:action) if params[:action]
      params.delete(:controller) if params[:controller]            
      params.delete(:id) if params[:id]            
      params.delete(:store_name) if params[:store_name]                  

      pagination_context = {}
      pagination_context['previous'] = link("#{I18n.t('previous')}", current_page - 1, path, params) if pagination.previous_page
      pagination_context['next'] = link("#{I18n.t('next')}", current_page + 1, path, params) if pagination.next_page
      pagination_context['parts'] = []

      hellip_break = false

      if page_count > 1
        1.upto(page_count) do |page|
          if current_page == page
            pagination_context['parts'] << no_link(page)
          elsif page == 1
            pagination_context['parts'] << link(page, page, path, params)
          elsif page == page_count - 1
            pagination_context['parts'] << link(page, page, path, params)
          elsif page <= current_page - window_size or page >= current_page + window_size
            next if hellip_break
            pagination_context['parts'] << no_link('&hellip;')
            hellip_break = true
            next
          else
            pagination_context['parts'] << link(page, page, path, params)
          end

          hellip_break = false
        end
      end

      context['paginate'] = pagination_context
      render_all(@nodelist, context)
    end
  end

  private

  def window_size
    3
  end

  def no_link(title)
    { 'title' => title, 'is_link' => false, 'hellip_break' => title == '&hellip;' }
  end

  def link(title, page, path, params = {})
    params[:page] = page
    { 'title' => title, 'url' => "#{path}?#{params.to_query}", 'is_link' => true}
  end
end

Liquid::Template.register_tag("paginate", Paginate)