module Imentore
  module Admin
    class SettingsController < Admin::BaseController
      inherit_resources
      actions :edit, :update

      before_filter :set_group

      def update
        update! { admin_edit_settings_path(@group) }
      end

      protected

      def update_resource(object, attributes)
        resource.attributes = params[:settings]
        if resource.valid?
          current_store.save
        end
      end

      def resource
        current_store.config
      end

      def set_group
        @group = params[:group]
      end
    end
  end
end