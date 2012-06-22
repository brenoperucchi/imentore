module Imentore
  class FeedbacksController < BaseController
    inherit_resources
    actions :new, :create

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
