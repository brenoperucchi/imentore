module Imentore
  class CustomersController < BaseController
    inherit_resources
    # nested_belongs_to :user
    # belongs_to :user
    # actions :new, :create, :destroy, :index

    # respond_to :json, only: [:create, :index, :destroy]

    # def index
    #   respond_with(collection.map { |Customer| Imentore::CustomerPresenter.new(Customer).to_json })
    # end

    # def create
    #   create! do |success, failure|
    #     success.json {
    #       render json: [Imentore::CustomerPresenter.new(@Customer).to_json]
    #     }
    #   end
    # end

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


    # protected

    def begin_of_association_chain
      current_store
    end

    def resource
      current_store
    end

  end
end
