module Imentore
  module Admin
    class ThemesController < Admin::BaseController
      inherit_resources
      actions :all

      def create
        create! { admin_theme_path(@theme) }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end