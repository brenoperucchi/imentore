module Imentore
  module Admin
    class DeliveryMethodsController < BaseController
      inherit_resources
      actions :all, except: [:show]

      def new
        @delivery_method = build_resource
        @delivery_method.handle = 'custom'
      end

      def update
        update! { admin_delivery_methods_path }
      end

      def create
        create! do |success, failure|
          success.html{
            @delivery_method.update_attribute(:handle, "custom")
            flash[:success] = t(:polymorphic_created, name: t(:delivery_method).capitalize)
            redirect_to admin_delivery_methods_path
          }
          failure.html{
            @delivery_method.handle = 'custom'
            # flash[:alert] = 'Could not updated'
            render :new }
        end
      end

      def destroy
        destroy! { admin_delivery_methods_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
