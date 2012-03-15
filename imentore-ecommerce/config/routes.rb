Rails.application.routes.draw do
  scope module: 'imentore' do

    match 'store/success', to: "stores#create_success"
    resources :stores, only: [:new, :create]

    root to: "stores#show"

    namespace :admin do
      resource :store, only: [:edit, :update]
      resources :domains, only: [:index, :create, :destroy]
      match 'store/settings/:group', to: "settings#edit", via: 'get', as: 'edit_settings'
      match 'store/settings/:group', to: "settings#update", via: 'put', as: 'update_settings'
    end
  end
end