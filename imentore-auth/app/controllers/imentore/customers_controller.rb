module Imentore
  class CustomersController < BaseController
    inherit_resources

    def new
      @customer = build_resource
      @customer.person_type = 'person'
      @customer.build_user
    end

    def create
      @customer = Imentore::Customer.new(params[:customer])
      @customer.store = current_store
      @customer.user.store = current_store
      create! do |success, failure|
        success.html do
          flash[:success] = t(:created_customer)
          sign_in(@customer.user)
          redirect_to session["user_return_to"]
        end
        failure.html do
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
