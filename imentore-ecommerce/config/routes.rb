Imentore::Core::Engine.routes.draw do
    match "store/success", to: "stores#create_success"
    resources :stores, only: [:new, :create]

    root to: "stores#show"

    namespace :admin do
      resource :store, only: [:edit, :update]
      match "store/settings/:group", to: "settings#edit",   via: "get", as: "edit_settings"
      match "store/settings/:group", to: "settings#update", via: "put", as: "update_settings"
      resources :domains, only: [:index, :create, :destroy] do
        resources :emails, only: [:index, :create, :update, :destroy], controller: "domain_emails"
      end
      resources :products,  only: [:index, :new, :create] do
        resources :variants, only: [:index], to:'product_variants' do
          resources :images, only: [:new, :create, :destroy, :index], to: 'images'
        end
      end
      resources :payment_methods, only: [:index, :edit, :update], path: "payment-providers"
    end

    resources :products,  only: [:index, :show]
    resource  :cart,      only: [:show, :create, :update, :destroy]

    match "checkout",           to: "checkouts#new",      via: "get",   as: "checkout"
    match "checkout/confirm",   to: "checkouts#confirm",  via: "put",   as: "confirm_checkout"
    match "checkout/complete",  to: "checkouts#complete", as: "complete_checkout"
end
