Imentore::Core::Engine.routes.draw do
    match "store/success", to: "stores#create_success"
    resources :stores, only: [:new, :create]

    root to: "stores#show"

    namespace :admin do
      resource :store, only: [:edit, :update]
      match "store/settings/:group", to: "settings#edit",   via: "get", as: "edit_settings"
      match "store/settings/:group", to: "settings#update", via: "put", as: "update_settings"
      resources :domains, only: [:index, :create, :destroy] do
        resources :emails, only: [:index, :create, :update, :destroy], to: "domain_emails"
      end
      resources :feedbacks, only: [:uodate, :edit, :index, :destroy]
      resources :coupons
      resources :product_brands,  only: [:new, :create]
      resources :products,  only: [:index, :new, :create, :edit, :update] do
        resources :options,  to: "product_options"
        resources :variants, to: 'product_variants' do
          resources :images, only: [:new, :create, :destroy, :index], to: 'images'
        end
      end
      resources :payment_methods,   only: [:index, :edit, :update, :new, :create], path: "payment-methods"
      resources :delivery_methods,  except: [:show], path: "delivery-methods"
      resources :orders,  only: [:index, :edit, :destroy] do
        get 'confirm_invoice', 'confirm_delivery', :on => :member
      end

      resources :categories, only: [:edit, :index, :update, :create, :destroy]
    end

    resources :feedbacks, only: [:create, :new]
    resources :order_assets, only: [:new, :create, :destroy, :index]
    resources :products,  only: [:index, :show]
    resource  :cart,      only: [:show, :create, :update, :destroy, :calculate_shipping] do
      get 'calculate_shipping', on: :member
    end

    match "pages/:page",                to: "pages#show",         as: "page"
    match "categories/*categories",     to: "categories#index",   as: "categories"
    match "coupon",                     to: "coupons#add_coupon", as: "add_coupon"
    match "checkout",           to: "checkouts#new",      as: "checkout"
    match "checkout/confirm",   to: "checkouts#confirm",  via: "get",   as: "confirm_checkout"
    match "checkout/confirm",   to: "checkouts#confirm",  via: "put",   as: "confirm_checkout"
    match "checkout/charge",    to: "checkouts#charge",   as: "charge_checkout"
    match "checkout/complete",  to: "checkouts#complete", as: "complete_checkout"
end
