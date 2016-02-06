module Imentore
  module Admin
    class EmployeesController < BaseController
      inherit_resources

      def new
        @employee = build_resource
        @employee.build_user
        new!
      end

      def edit
        @employee = current_store.employees.find(params[:id])
        (@employee.addresses = [@employee.addresses.new]) if @employee.addresses.blank?
        edit!
      end

      def update
        update! { admin_employees_path }
      end

      def destroy
        destroy! { admin_employees_path }
      end

      def create
        @employee = current_store.employees.new(employee_params)
        @employee.user.store = current_store
        @employee.department = "admin"
        create! do |success, failure|
          success.html do
            flash[:success] = t(:object_created)
            redirect_to admin_employees_path
          end
          failure.html do
            flash[:alert] = t(:object_failure)
            render :new
          end
        end

      end

      protected

      def employee_params
        params.require(:employee).permit(:active, :name, :brand, :irs_id, :national_id, user_attributes:[:email, :id, :password, :password_confirmation], addresses_attributes:[:name, :street, :complement, :city, :country, :state, :zip_code, :phone])
      end


      def begin_of_association_chain
        current_store
      end

    end
  end
end
