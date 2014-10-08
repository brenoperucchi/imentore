module Imentore
  class Datatable
    include Imentore::Core::Engine.routes.url_helpers
    include ActionView::Context
    include ActionView::Helpers
    include ActionView::Helpers::TagHelper
    include ApplicationHelper


    delegate :params, :h, :link_to, :number_to_currency, :button_status, :button_datatable, to: :@view

    def initialize(view, current_store)
      @view = view
      @current_store = current_store
    end

    def as_json(options = {})
      {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: resources.count,
        iTotalDisplayRecords: resources.total_entries,
        aaData: data
      }
    end

  private

    # def data
    #   products.map do |product|
    #     [
    #       product.id,
    #       button_status(product.active, edit_admin_product_path(product)),
    #       h(product.created_at.strftime("%B %e, %Y")),
    #       product.name,
    #       product.handle,
    #       button_datatable(product, edit_admin_product_path(product), 'icon-black icon-edit', 'edit') + ' ' + button_datatable(product, admin_product_variants_path(product), 'icon-black icon-share', 'variants') + ' ' + button_datatable(product, admin_product_options_path(product), 'icon-black icon-plus', 'options')
    #     ]
    #   end
    # end

    # def products
    #   @products ||= fetch_products
    # end

    # def fetch_products
    #   products = @current_store.products.order("#{sort_column} #{sort_direction}")
    #   products = products.page(page).per_page(per_page)
    #   if params[:sSearch].present?
    #     products = products.where("id like :search or name like :search or handle like :search", search: "%#{params[:sSearch]}%")
    #   end
    #   products
    # end

    def page
      params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
      columns = %w[id active created_at name handle]
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
  end
end