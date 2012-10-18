module Imentore
  class CustomersController < BaseController
    inherit_resources

    def new
      @customer = build_resource
      @customer.build_user
    end

    def create
      @customer = Imentore::Customer.new(params[:customer])
      @customer.store = current_store
      @customer.user.store = current_store
      create! do |success, failure|
        success.html do
          flash[:success] = t(:created_customer)
          redirect_to new_user_session_path
        end
        failure.html do
          flash[:alert] = @customer.errors.full_messages
          render :new
        end
      end
    end

    protected

    def begin_of_association_chain
      current_store
    end

    def resource
      current_store
    end

  end
end
