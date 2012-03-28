Imentore::Core::Engine.routes.draw do
    match 'store/success', to: "stores#create_success"
    resources :stores, only: [:new, :create]

    root to: "stores#show"

    namespace :admin do
      resource :store, only: [:edit, :update]
      match 'store/settings/:group', to: "settings#edit", via: 'get', as: 'edit_settings'
      match 'store/settings/:group', to: "settings#update", via: 'put', as: 'update_settings'
      resources :domains, only: [:index, :create, :destroy] do 
      	resources :domain_mails, only: [:index, :update, :create]
      end
    end
end