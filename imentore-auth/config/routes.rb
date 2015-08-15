Imentore::Core::Engine.routes.draw do

  resources :customers, only: [:new, :create]

  devise_for :users,
    class_name: 'Imentore::User',
    path_names: {sign_in: 'login', sign_out: 'logout'},
    controllers:  {:sessions => "imentore/client/sessions",
                   :passwords => "imentore/client/passwords"
                  }
    # path: => 'client'

  devise_scope :user do
    get '/client/login',   to: 'client/sessions#new',    as: 'new_client_session'
    post '/client/login',  to: 'client/sessions#create', as: 'client_session'
    # delete '/client/logout',  to: 'client/sessions#destroy', as: 'destroy_client_session'
    match '/client/logout',  to: 'client/sessions#destroy', as: 'destroy_client_session', via:[:delete, :get]
  end

  devise_scope :user do
    get '/admin/login',   to: 'admin/sessions#new',    as: 'new_admin_session'
    post '/admin/login',  to: 'admin/sessions#create', as: 'admin_session'
    delete '/admin/logout',  to: 'admin/sessions#destroy', as: 'destroy_admin_session'
  end

  devise_scope :user do
    get '/manager/login',   to: 'manager/sessions#new',    as: 'new_manager_session'
    post '/manager/login',  to: 'manager/sessions#create', as: 'manager_session'
    delete '/manager/logout',  to: 'manager/sessions#destroy', as: 'destroy_manager_session'
  end

  # match 'admin',              to: "admin/sessions#new", via: "get"
  # match 'client',             to: "client/sessions#new", via: "get"
end