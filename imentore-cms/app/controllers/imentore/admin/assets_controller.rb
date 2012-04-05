module Imentore
  module Admin
    class AssetsController < Admin::BaseController
      inherit_resources
      belongs_to :theme, parent_class: Imentore::Theme
      # actions :new, :create

      def create
        create! { admin_theme_path(@theme) }
      end

      def begin_of_association_chain
        current_store.themes.find(params[:theme_id])
      end

    end
  end
end