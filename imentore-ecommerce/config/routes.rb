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
      resources :products,          only: [:index, :new, :create]
      resources :payment_methods,   only: [:index, :edit, :update], path: "payment-methods"
      resources :delivery_methods,  except: [:show], path: "delivery-methods"
    end

    resources :products,  only: [:index, :show]
    resource  :cart,      only: [:show, :create]

    match "checkout",           to: "checkouts#new",      as: "checkout"
    match "checkout/confirm",   to: "checkouts#confirm",  via: "put",   as: "confirm_checkout"
    match "checkout/charge",    to: "checkouts#charge",   as: "charge_checkout"
    match "checkout/complete",  to: "checkouts#complete", as: "complete_checkout"
end
