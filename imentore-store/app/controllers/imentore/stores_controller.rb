module Imentore
  class StoresController < ApplicationController
    inherit_resources

    before_filter :check_current_store, only: [:show]

    def create
      @store = Store.new(params[:imentore_store])
      @store.name = @store.url
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

    def current_store
      @current_store ||= Store.find_by_url(request.subdomain)
    end

    def check_current_store
      unless current_store
        render(:not_found, status: 404)
        return false
      end
    end
  end
end