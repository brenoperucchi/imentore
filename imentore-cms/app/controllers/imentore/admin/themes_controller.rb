module Imentore
  module Admin
    class ThemesController < Admin::BaseController

      before_filter :uniqueness_active, only:[:update, :create]

      inherit_resources
      actions :all

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

      def collection
        @themes = begin_of_association_chain.themes.theme_system
      end

      protected

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