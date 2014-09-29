module Imentore
  class StoresController < BaseController
    inherit_resources

    skip_before_filter :check_store, only: [:new, :create, :create_success]

    def contact
      
    end

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
            password = params[:store][:owner_attributes][:user_attributes][:password]
            Imentore::SendEmailMailer.create_store(@store.owner.user.email, @store, password).deliver
            if request.server_port == '3000'
              redirect_to "http://#{@store.url}.imentore.dev:3000" 
            else
              redirect_to "http://#{@store.url}.imentore.com.br"
            end
            @store.create_defaults
          else
            render 'new'
          end
        }
      end
    end

    def show
      store = current_store
      @products = store.products.active.limit(current_store.config.limit_product_newest).order('id desc').map { |product| ProductDrop.new(product) }
      @features = store.products.active.featured.limit(current_store.config.limit_product_featured).order('id desc').map { |product| ProductDrop.new(product) }
    end
  end
end