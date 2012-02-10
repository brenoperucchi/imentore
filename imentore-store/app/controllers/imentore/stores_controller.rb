module Imentore
  class StoresController < BaseController
    inherit_resources

    skip_before_filter :check_store, only: [:new, :create, :create_success]

    def create
      @store = Store.new(params[:imentore_store])
      @store.brand = @store.url.capitalize
      @store.owner.user.store = @store
      @store.owner.person_type = 'person'
      @store.owner.name = "Name"
      create! { store_success_url }
    end

    def create_success
    end

    def show
      @store = current_store
    end
  end
end