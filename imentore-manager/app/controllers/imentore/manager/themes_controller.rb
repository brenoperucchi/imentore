module Imentore
  module Manager
    class ThemesController < Manager::BaseController
      inherit_resources
      defaults :resource_class => Manager::Theme, :collection_name => 'themes', :instance_name => 'theme'
      def index
        @themes = Imentore::Manager::Theme.all
      end

      def new
        @theme = Imentore::Manager::Theme.new
      end

      def update
        update! { manager_themes_path }
      end

      def destroy
        destroy! { manager_themes_path }
      end

      def create
        @theme = Imentore::Manager::Theme.new(theme_params)
        if @theme.save
          redirect_to manager_themes_path
        else 
          render :new
        end
      end

      def reinstall_templates
        admin_theme = Imentore::Manager::Theme.find(params[:id])
        admin_theme.reinstall_templates
        flash[:success] = "Successfully created..."
        redirect_to manager_themes_path      
      end

      def update_stores
        admin_theme = Imentore::Manager::Theme.find(params[:id])
        admin_theme.update_stores
        flash[:success] = "Successfully created..."
        redirect_to manager_themes_path      
      end

      def install_stores
        admin_theme = Imentore::Manager::Theme.find(params[:id])
        admin_theme.install_stores
        flash[:success] = "Successfully created..."
        redirect_to manager_themes_path
      end

      protected
      def theme_params
        params.require(:manager_theme).permit(:name, :active, :user_for)
      end


    end
  end
end