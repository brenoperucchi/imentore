module Imentore
  class StoresController < BaseController
    include SqlTemplate::ResolverMethods
    skip_before_action :current_cart, only:[:create, :new]

    inherit_resources
    respond_to :html, :json
    skip_before_action :check_store, only: [:new, :create, :create_success]


    def render_template
      if params[:template]
        template = render_to_controller(params[:template])
        respond_to do |format|
          format.html { render :inline => template  }
          format.json do 
            render :json => {response: template}, status: 200
          end
        end
      end
    end

    def contact
    end
    
    def new
      @store = Store.new
      @store.build_owner
      @store.owner.build_user
      new!
    end

    def create
      @store = Imentore::Store.new(store_params)
      @store.brand = @store.url.capitalize
      @store.name = @store.url.capitalize
      @store.owner.user.store = @store
      @store.owner.person_type = 'person'
      @store.owner.department = 'owner'
      @store.config.email_contact = @store.owner.user.email
      respond_to do |wants|
        wants.html {  
          if @store.save
            password = params[:store][:owner_attributes][:user_attributes][:password]
            Imentore::SendEmailMailer.create_store(@store.owner.user.email, @store, password).deliver
            Imentore::SendEmailMailer.notice_imentore(@store).deliver
            @store.create_defaults
            if Rails.env == 'development'
              redirect_to "http://#{@store.url}.imentore.dev:4000" 
            else
              redirect_to "http://#{@store.url}.imentore.com.br"
            end
          else
            render :new
          end
        }
      end
    end

    def show
      store = current_store
      @products = store.products.active.order('id desc').map { |product| ProductDrop.new(product) }
      @features = store.products.active.featured.order('id desc').map { |product| ProductDrop.new(product) }
    end

    protected

    def store_params
      params.require(:store).permit(:url, :irs_id, :plan_id, :term, owner_attributes: [:id, :name, :irs_id, user_attributes:[:password, :email] ])
    end
  end
end