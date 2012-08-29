module Imentore
  module Deal
    class ProposesController < BaseController
      inherit_resources

      skip_before_filter :check_store, :authorize_admin, :current_cart, :current_store
      belongs_to :project, parent_class: Imentore::Project


      def create
        # binding.pry
        create! { deal_project_path(parent) }
      end

    end
  end
end