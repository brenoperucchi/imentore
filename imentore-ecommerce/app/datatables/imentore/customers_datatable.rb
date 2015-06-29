module Imentore
  class CustomersDatatable < Imentore::Datatable

  private

    def data
      resources.map do |customer|
        [
          customer.id,
          button_status(customer.active, edit_admin_customer_path(customer)),
          customer.name,
          customer.user.try(:email),
          customer.created_at.strftime("%B %e, %Y"),
          button_link(customer),
        ]
      end
    end

    def button_link(resource)
      capture do 
        button_datatable(resource, edit_admin_customer_path(resource), 'btn btn-small', 'icon-edit icon-black', 'edit') +
        button_datatable(resource, admin_customer_path(resource), 'btn btn-danger btn-small', 'icon-white icon-remove', 'remove', :delete) 
      end
    end


    def resources
      @customers ||= fetch_customers
    end

    def fetch_customers
      customers = @current_store.customers.order("#{sort_column} #{sort_direction}")
      customers = customers.page(page).per_page(per_page)
      if params[:sSearch].present?
        customers = customers.joins(:user).where("imentore_customers.id like :search or imentore_customers.created_at like :search or imentore_customers.name like :search or imentore_users.email like :search", search: "%#{params[:sSearch]}%")
      end
      customers
    end

  end
end