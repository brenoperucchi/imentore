module Imentore
  class OrdersDatatable < Imentore::Datatable

  private

    def data
      resources.map do |resource|
        [
          resource.id,
          button_status(resource),
          resource.created_at.strftime("%B %e, %Y"),
          resource.customer_name,
          resource.customer_email,
          number_with_price(resource.total_amount),
          button_link(resource),
        ]
      end
    end

    def button_status(resource)
      capture do
        " " +
        button_order_status(resource.status)
      end
    end

    def button_link(resource)
      capture do 
        button_datatable(resource, edit_admin_order_path(resource), 'btn btn-small', 'icon-edit icon-black', 'edit') +
        if resource.can_cancel?
          button_datatable(resource, cancel_admin_order_path(resource), 'btn btn-danger btn-small', 'icon-white icon-edit', 'cancel')
        # else
          # button_datatable(resource, admin_order_path(resource), 'btn btn-inverse btn-small', 'icon-trash icon-white', 'remove', :delete)
        end
      end
    end

    def resources
      @orders ||= fetch_orders
    end

    def fetch_orders
      orders = @current_store.orders.order("#{sort_column} #{sort_direction}")
      orders = orders.page(page).per_page(per_page)
      if params[:sSearch].present?
        orders = orders.joins(:invoice).where("imentore_orders.id like :search or imentore_orders.created_at like :search or imentore_orders.customer_email like :search or imentore_invoices.amount like :search", search: "%#{params[:sSearch]}%")
      end
      orders
    end

    def sort_column
      columns = %w[id active created_at customer_name customer_email ]
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end


  end
end