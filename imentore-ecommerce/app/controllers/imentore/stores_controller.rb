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
      @store.config.email_contact = @store.owner.user.email
      respond_to do |wants|
        wants.html {  
          if @store.save
            Imentore::SendEmailMailer.create_store(@store.owner.user.email, @store).deliver
            if request.server_port == '3000'
              redirect_to "http://#{@store.url}.imentore.dev:3000" 
            else
              redirect_to "http://#{@store.url}.imentore.com.br"
            end
          else
            render 'new'
          end
        }
      end
    end

    def show
      store = current_store
      @products = store.products.active.map { |product| ProductDrop.new(product) }
    end
  end
end
