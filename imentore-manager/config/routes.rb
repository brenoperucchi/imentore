Imentore::Core::Engine.routes.draw do
  namespace :manager do
    # root :to => "dashboard#index"
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
      get '/reinstall_theme/:id', to: 'stores#reinstall_theme' , as: 'reinstall_theme', :on => :collection
      # get '/reinstall_theme/:theme' => 'manager/stores#reinstall_theme'
    end
    
  end

  # devise_scope :user do
  #   get '/manager/login',   to: 'manager/sessions#new',    as: 'new_manager_session'
  #   post '/manager/login',  to: 'manager/sessions#create', as: 'manager_session'
  #   delete '/manager/logout',  to: 'manager/sessions#destroy', as: 'destroy_manager_session'
  # end
end