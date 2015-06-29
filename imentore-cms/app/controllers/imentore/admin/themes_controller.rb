module Imentore
  module Admin
    class ThemesController < Admin::BaseController
      inherit_resources

      before_action :uniqueness_active, only:[:update, :create]


      def create
        create! { admin_theme_path(@theme) }
      end

      def update
        update! do |success, failure|
          success.html{ redirect_to admin_themes_path }
          failure.html{ render :show }
        end
      end

      def destroy
        destroy! { admin_themes_path }
      end
      
      protected

      def theme_params
        params.require(:theme).permit(:active, :name)
      end

      def uniqueness_active
        if params[:theme][:active] == '1'
          current_store.themes.find_by_active(true).update_attribute(:active, false) if current_store.themes.find_by_active(true)
        end
      end

      def begin_of_association_chain
        current_store
      end
    end
  end
end