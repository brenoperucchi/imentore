module Imentore
  class StoresController < ApplicationController
    inherit_resources

    def create
      @store = Store.new(params[:imentore_store])
      @store.name = @store.url
      @store.owner.person_type = 'person'
      @store.owner.name = "Name"
      create! { store_success_url }
    end

    def create_success
    end

  end
end