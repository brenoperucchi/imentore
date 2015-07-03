# Paginate a collection
#
# Usage:
#
# {% paginate contents.projects by 5 %}
#   {% for project in paginate.collection %}
#     {{ project.name }}
#   {% endfor %}
#  {% endpaginate %}

require 'i18n'
    class PaginateTag < Liquid::Block
      Syntax     = /(#{Liquid::QuotedFragment})\s*(by\s*(\d+))?/

      def initialize(tag_name, markup, options)
        super

        if markup =~ Syntax
          @collection_name = $1
          @page_size = if $2
            $3.to_i
          else
            20
          end

          @attributes = { 'window_size' => 3 }
          markup.scan(Liquid::TagAttributes) do |key, value|
            @attributes[key] = value
          end
        else
          raise SyntaxError.new("Syntax Error in tag 'paginate' - Valid syntax: paginate [collection] by number")
        end
      end

      def render(context)
        @context = context

        context.stack do
          path = context.registers[:controller].request.path
          params = context.registers[:controller].params.clone
          collection = context[@collection_name]


          pagination = {
            'page_size'      => per_page,
            'current_page'   => current_page,
            'current_offset' => (current_page-1) * per_page
          }
          context['paginate'] = pagination
          
          collection_model = @context.registers[:action_view].assigns["products_model"]
          if collection_model
            paginate_collection = collection_model.paginate(
              :page       => current_page,
              :per_page   => per_page)  
            new_collection = paginate_collection.map{|product| Imentore::ProductDrop.new(product)}
            context[@collection_name] = new_collection
          end


          collection_size  = context[@collection_name].size

          raise ArgumentError.new("Cannot paginate array '#{@collection_name}'. Not found.") if collection_size.nil?

          page_count = paginate_collection.try(:total_pages) || 0

          pagination['current_offset']  = (current_page-1) * per_page
          pagination['current_page']    = current_page
          pagination['page_size']       = per_page
          pagination['pages']           = page_count

          pagination['items']           = paginate_collection.try(:total_entries)
          pagination['items_page']      = paginate_collection.try(:count)

          pagination['previous']   = link(I18n.t(:previous_label, scope: 'will_paginate').html_safe, current_page - 1) unless 1 >= current_page
          pagination['next']       = link(I18n.t(:next_label, scope: 'will_paginate').html_safe, current_page + 1) unless page_count < current_page + 1
          pagination['parts']      = []
          hellip_break = false

          if page_count > 1
            1.upto(page_count) do |page|
              if current_page == page
                pagination['parts'] << no_link(page)
              elsif page == 1
                pagination['parts'] << link(page, page)
              elsif page == page_count - 1
                pagination['parts'] << link(page, page)
              elsif page <= current_page - @attributes['window_size'] || page >= current_page + @attributes['window_size']
                next if hellip_break
                pagination['parts'] << no_link('&hellip;')
                hellip_break = true
                next
              else
                pagination['parts'] << link(page, page)
              end
              hellip_break = false
            end
          end

          super
        end
      end

      private

      def per_page?
        @context.registers[:controller].params[:per_page].present?
      end

      def per_page
        if per_page?
          @context.registers[:controller].params[:per_page].to_i if per_page?  
        else
          @page_size
        end
      end

      def current_page
        _current_page = @context.registers[:controller].params[:page]
        # _current_page = 1 if @context[@collection_name].count < per_page
        # _current_page
        _current_page.nil? ? 1 : _current_page.to_i
      end

      def current_url
        current_url = @context.registers[:controller].request.fullpath.gsub(/(per_page=)[0-9]+&?/, '')
        current_url = current_url.gsub(/(page=)[0-9]+&?/, '')
        current_url = current_url.slice(0..-2) if current_url.last == '?' || current_url.last == '&'
        current_url
      end

      def no_link(title)
        { 'title' => title, 'is_link' => false, 'hellip_break' => title == '&hellip;' }
      end

      def link(title, page)
        _current_url = %(#{current_url}#{current_url.include?('?') ? '&' : '?'}page=#{page})
        _current_url += "#{_current_url.include?('?') ? '&' : '?'}per_page=#{per_page}"
        { 'title' => title, 'url' => _current_url, 'is_link' => true }
      end

end
Liquid::Template.register_tag('paginate', PaginateTag)

# require 'will_paginate/array'
# # Paginate a collection
# #
# # Usage:
# #
# # {% paginate contents.projects by 5 %}
# #   {% for project in paginate.collection %}
# #     {{ project.name }}
# #   {% endfor %}
# #  {% endpaginate %}
# #

# module Liquid
#   module Rails
#     class PaginateTag < ::Liquid::Block
#       # Syntax = /(#{::Liquid::Expression}+)\s+by\s+([0-9]+)/
#       Syntax = /(#{::Liquid::QuotedFragment})\s*(by\s*(\d+))?/


#       def initialize(tag_name, markup, tokens)
#         if markup =~ Syntax
#           @collection_name = $1
#           @per_page = $2.to_i
#         else
#           raise ::Liquid::SyntaxError.new("Syntax Error in 'paginate' - Valid syntax: paginate <collection> by <number>")
#         end
#         super
#       end

#       def render(context)
#         context.stack do
#           collection = context[@collection_name]
#           params = context.registers[:controller].params.clone

#           raise ::Liquid::ArgumentError.new("Cannot paginate array '#{@collection_name}'. Not found.") if collection.nil?

#           pagination = collection.send(:paginate, {
#             :include  => [:images, :master],
#             :page       => params[:page],
#             :per_page   => @per_page })
          
#           context[@collection_name] = pagination  

#           page_count, current_page = pagination.total_pages, pagination.current_page

#           path = context.registers[:controller].request.path
#           params.delete(:page) if params[:page]
#           params.delete(:action) if params[:action]
#           params.delete(:controller) if params[:controller]            
#           params.delete(:id) if params[:id]            
#           params.delete(:store_name) if params[:store_name]                  

#           pagination_context = {}
#           pagination_context['previous'] = link("#{I18n.t('previous')}", current_page - 1, path, params) if pagination.previous_page
#           pagination_context['next'] = link("#{I18n.t('next')}", current_page + 1, path, params) if pagination.next_page
#           pagination_context['parts'] = []

#           hellip_break = false

#           if page_count > 1
#             1.upto(page_count) do |page|
#               if current_page == page
#                 pagination_context['parts'] << no_link(page)
#               elsif page == 1
#                 pagination_context['parts'] << link(page, page, path, params)
#               elsif page == page_count - 1
#                 pagination_context['parts'] << link(page, page, path, params)
#               elsif page <= current_page - window_size or page >= current_page + window_size
#                 next if hellip_break
#                 pagination_context['parts'] << no_link('&hellip;')
#                 hellip_break = true
#                 next
#               else
#                 pagination_context['parts'] << link(page, page, path, params)
#               end

#               hellip_break = false
#             end
#           end

#           context['paginate'] = pagination_context
#           render_all(@nodelist, context)
#         end
#       end

#       private

#       def window_size
#         3
#       end

#       def no_link(title)
#         { 'title' => title, 'is_link' => false, 'hellip_break' => title == '&hellip;' }
#       end

#       def link(title, page, path, params = {})
#         params[:page] = page
#         { 'title' => title, 'url' => "#{path}?#{params.to_query}", 'is_link' => true}
#       end
#     end
#   end
# end
# Liquid::Template.register_tag('paginate', Liquid::Rails::PaginateTag)