module Imentore
  module Admin
    class TemplatesController < Admin::BaseController
      include Imentore::Core::Engine.routes.url_helpers
      inherit_resources
      belongs_to :theme, parent_class: Imentore::Theme
      before_action :uniqueness_default, only:[:update, :create]
      before_action :set_template, only: [:show, :edit]
      before_action :parent, only: [:index, :layouts, :show, :edit, :index, :new]
      respond_to :html, :json, :xml
      # custom_actions :collection => :layouts

      def layouts
      end

      def index
      end

      def new
        @kind = params[:kind]
        new!
      end

      def show
        respond_with(@template)
      end

      def edit
        @kind = @template.kind
      end

      def create
        create! { admin_theme_path(params[:theme_id]) }
      end

      def update
        update!(template_params) {admin_theme_templates_path(id: params[:theme_id])}
      end

      def destroy
        destroy! { admin_theme_path(params[:theme_id]) }
      end

      def view_default
        template = parent.templates.find(params[:id])
        @template = template.admin_template
        @kind = @template.kind
      end


      protected

      def parent
        @theme = current_store.themes.find(params[:theme_id])
      end

      def set_template
        @template = parent.templates.find(params[:id])
      end

      def template_params
        params.require(:template).permit(:default, :body, :path, :kind, :layout_id)
      end

      ## TODO in the model
      def uniqueness_default
        @theme = current_store.themes.find(params[:theme_id])
        if params[:template][:default] == '1'
          @theme.templates.find_by_default_and_kind(true,'layout').update_attribute(:default, false) if @theme.templates.find_by_default_and_kind(true,'layout')
        end
      end

    end
  end
end