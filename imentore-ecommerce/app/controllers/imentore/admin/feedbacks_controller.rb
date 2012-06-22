module Imentore
  module Admin
    class FeedbacksController < BaseController
      inherit_resources
      actions :index, :destroy, :edit, :update

      def create
        create! { admin_feedbacks_path}
      end

      def update
        update! { admin_feedbacks_path}
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
