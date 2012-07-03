module Imentore
  class StoresController < BaseController
    inherit_resources

    skip_before_filter :check_store, only: [:new, :create, :create_success]

    def new
      @store = Store.new
      @store.build_owner
      @store.owner.build_user
      new!
    end

    def create
      @store = Store.new(params[:store])
      @store.brand = @store.url.capitalize
      @store.owner.user.store = @store
      @store.owner.person_type = 'person'
      @store.owner.name = "Name"
      create! { store_success_url }
    end

    def create_success
    end

    def show
      store = current_store
      @products = store.products.map { |product| ProductDrop.new(product) }
    end
  end
end
