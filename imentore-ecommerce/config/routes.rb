Imentore::Core::Engine.routes.draw do

    resources :stores, only: [:new, :create]

    root to: "stores#show"

    namespace :admin do
      resource :store, only: [:edit, :update]
      get "store/settings/:group", to: "settings#edit",   via: "get", as: "edit_settings"
      put "store/settings/:group", to: "settings#update", as: "update_settings"
      resources :domains, only: [:index, :create, :destroy] do
        resources :emails, only: [:index, :create, :update, :destroy], to: "domain_emails"
      end
      resources :feedbacks, only: [:uodate, :edit, :index, :destroy]
      resources :coupons
      resources :product_brands,  only: [:new, :create]
      resources :products do
        resources :options,  to: "product_options"
        resources :variants, to: 'product_variants' do
          resources :images, only: [:create, :destroy, :index], to: 'images'
        end
      end
      resources :payment_methods, path: "payment-methods"
      resources :delivery_methods,  except: [:show], path: "delivery-methods"
      resources :orders,  only: [:index, :edit, :destroy, :update] do
        get 'confirm_invoice', 'confirm_delivery', 'cancel', :on => :member
        put 'confirm_invoice', 'confirm_delivery', 'cancel', :on => :member
      end

      resources :categories, only: [:edit, :index, :update, :create, :destroy]
    end

    resources :stores, only: [:show] do
      resources :feedbacks, only: [:create, :new]
    end
    resources :order_assets, only: [:new, :create, :destroy, :index]
    resources :products,  only: [:index, :show]
    resource  :cart,      only: [:show, :create, :update, :destroy, :calculate_shipping] do
      get 'calculate_shipping', on: :member
    end
    
    get "store/success",              to: "stores#create_success"
    get "contact",                    to: "stores#contact",       as: "store_contact"
    get "product/:handle",            to: "products#handle",      as: 'product_handle'
    post  "products/search",           to: "products#search",      as: 'products_search'
    get   "products/result/:name",     to: "products#result",      as: 'products_result'
    get "notices/:handle",            to: "notices#show",         as: "notices"
    get "pages/:page",                to: "pages#show",           as: "pages"
    get "categories/*categories",     to: "categories#index",     as: "categories"
    get "coupon",                     to: "coupons#add_coupon",   as: "add_coupon"
    get "checkout",               to: "checkouts#new",                    as: "checkout"
    # get "checkout/address",       to: "checkouts#address",  via: "get",   as: "address_checkout"
    match "checkout/address",       to: "checkouts#address",   as: "address_checkout",  via: [:get, :put]
    # get "checkout/:id/confirm",   to: "checkouts#confirm",  via: "get",   as: "confirm_checkout"
    match "checkout/:id/confirm",   to: "checkouts#confirm",  as: "confirm_checkout", via:[:get, :put]
    get "checkout/charge",        to: "checkouts#charge",   as: "charge_checkout"
    get "checkout/:id/complete",  to: "checkouts#complete", as: "complete_checkout"
    get "return_mp/:invoice_id",  to: "checkouts#return_mp", as: 'return_mp'
    get "return_pd/:invoice_id",  to: "checkouts#return_pd", as: 'return_pd'
    get "return_pg/:invoice_id",  to: "checkouts#return_pg", as: 'return_pg'
    get "sync_pd/:invoice_id",    to: "checkouts#sync_pd",   as: 'sync_pd'
    get "sync_pg/:store_id",      to: "checkouts#sync_pg",   as: 'sync_pg'
    get "sync_mp/:store_id",      to: "checkouts#sync_mp",   as: 'sync_mp'
end
