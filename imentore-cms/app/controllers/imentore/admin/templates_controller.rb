module Imentore
  module Admin
    class TemplatesController < Admin::BaseController
      inherit_resources
      belongs_to :theme, parent_class: Imentore::Theme

      def create
        create! { admin_theme_path(params[:theme_id]) }
      end

      def update
        update! { edit_admin_theme_template_path(params[:theme_id], params[:id]) }
      end

      def destroy
        destroy! { admin_theme_path(params[:theme_id]) }
      end

    end
  end
end