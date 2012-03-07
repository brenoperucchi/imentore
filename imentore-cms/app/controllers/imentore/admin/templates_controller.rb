module Imentore
  module Admin
    class TemplatesController < Admin::BaseController
      inherit_resources
      belongs_to :theme, parent_class: Imentore::Theme
      actions :new, :create

      def create
        create! { admin_theme_path(@theme) }
      end
    end
  end
end