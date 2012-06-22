module Imentore
  module Admin
    class EmployeesController < BaseController
      inherit_resources

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

      protected

      def begin_of_association_chain
        current_store
      end

    end
  end
end
