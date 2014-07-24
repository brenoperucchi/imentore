module Imentore
  class ProductsDatatable < Imentore::Datatable

  private

    def data
      resources.map do |product|
        [
          product.id,
          button_status(product.active, edit_admin_product_path(product)),
          h(product.created_at.strftime("%B %e, %Y")),
          product.name,
          product.handle,
          button_datatable(product, edit_admin_product_path(product), 'icon-black icon-edit', 'edit') + ' ' + button_datatable(product, admin_product_variants_path(product), 'icon-black icon-share', 'variants') + ' ' + button_datatable(product, admin_product_options_path(product), 'icon-black icon-plus', 'options')
        ]
      end
    end

    def resources
      @products ||= fetch_products
    end

    def fetch_products
      products = @current_store.products.order("#{sort_column} #{sort_direction}")
      products = products.page(page).per_page(per_page)
      if params[:sSearch].present?
        products = products.where("id like :search or created_at like :search or name like :search", search: "%#{params[:sSearch]}%")
      end
      products
    end

  end
end