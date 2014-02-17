AdminImentore::Admin::Engine.routes.draw do
    namespace :admin_imentore do
      root to: "dashboard#index", as: 'dashboard'
      resources :send_emails do
        get 'install_stores', 'update_stores', :on => :member
      end

      resources :themes do
        get 'install_stores', :on => :member
        get 'update_stores', :on => :member
        get 'reinstall_templates', :on => :member
        resources :assets
        resources :templates do
          get 'update_stores', :on => :member
          get 'install_stores', :on => :member
        end
      end
      resources :stores do 
        get 'install_store', :on => :member
      end

    end

  devise_for :users,
    class_name: 'Imentore::User',
    path_names: {sign_in: 'login', sign_out: 'logout'},
    controllers:  {:sessions => "imentore/client/sessions",
                   :passwords => "imentore/client/passwords"
                  }
  devise_scope :user do
    get '/admin_imentore/login',   to: 'admin_imentore/sessions#new',    as: 'new_admin_imentore_session'
    post '/admin_imentore/login',  to: 'admin_imentore/sessions#create', as: 'admin_imentore_session'
    delete '/admin_imentore/logout',  to: 'admin_imentore/sessions#destroy', as: 'destroy_admin_imentore_session'
  end
end