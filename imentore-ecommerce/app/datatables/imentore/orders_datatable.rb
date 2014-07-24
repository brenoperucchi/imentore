module Imentore
  class OrdersDatatable < Imentore::Datatable

  private

    def data
      resources.map do |resource|
        [
          resource.id,
          button_status(resource.status, edit_admin_order_path(resource)),
          h(resource.created_at.strftime("%B %e, %Y")),
          resource.customer_email,
          button_datatable(resource, edit_admin_order_path(resource), 'icon-black icon-edit', 'edit') + ' ' + button_datatable(resource, admin_order_path(resource), 'icon-black icon-remove ', t(:remove))
        ]
      end
    end

    def resources
      @orders ||= fetch_orders
    end

    def fetch_orders
      orders = @current_store.orders.order("#{sort_column} #{sort_direction}")
      orders = orders.page(page).per_page(per_page)
      if params[:sSearch].present?
        orders = orders.where("id like :search or name like :search or created_at like :search or customer_email like :search", search: "%#{params[:sSearch]}%")
      end
      orders
    end

  end
end