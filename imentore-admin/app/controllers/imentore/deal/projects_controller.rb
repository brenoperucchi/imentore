module Imentore
  module Deal
    class ProjectsController < BaseController
    # class ProjectsController < ApplicationController
      inherit_resources

      # defaults :route_prefix => 'deal'
      skip_before_filter :check_store, :authorize_admin, :current_cart, :current_store
      # actions :new


      # def new
      #   @project = Imentore::Project.new
      # end

      def create
        create! { deal_path}
      end

      # def begin_of_association_chain
      #   current_user
      # end

    end
  end
end