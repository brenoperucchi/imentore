module Imentore
  module Admin

    class AssetsController < Admin::BaseController
      inherit_resources
      # belongs_to :theme, parent_class: Imentore::Theme
      # actions :new, :create, :show

      # def new
      #   new!
      #   # binding.pry
      # end

      def destroy
        destroy! do
          # flash[:notice] = "Successfully deleted"
          admin_theme_path(@asset.theme)
        end
      end

      def create
        create! do |success, failure|
          failure.html{ redirect_to admin_theme_path(@theme) }
          success.html{
            redirect_to admin_theme_path(@asset.theme)
          }
        end
      end

      def begin_of_association_chain
        current_store.themes.find(params[:theme_id])
      end

    end
  end
end