module Imentore
  module Admin
    class TemplatesController < Admin::BaseController
      inherit_resources
      belongs_to :theme, parent_class: Imentore::Theme
      before_filter :uniqueness_default, only:[:update, :create]

      def new
        @kind = params[:kind]
        new!
      end

      def edit
        @template = parent.templates.find(params[:id])
        @kind = @template.kind
      end

      def create
        create! { admin_theme_path(params[:theme_id]) }
      end

      def update
        update! { edit_admin_theme_template_path(params[:theme_id], params[:id]) }
      end

      def destroy
        destroy! { admin_theme_path(params[:theme_id]) }
      end

      protected

      def uniqueness_default
        @theme = current_store.themes.find(params[:theme_id])
        if params[:template][:default] == '1'
          @theme.templates.find_by_default_and_kind(true,'layout').update_attribute(:default, false) if @theme.templates.find_by_default_and_kind(true,'layout')
        end
      end

    end
  end
end