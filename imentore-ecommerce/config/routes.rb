Imentore::Core::Engine.routes.draw do

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
      resources :payment_methods, path: "payment-methods"
      resources :delivery_methods,  except: [:show], path: "delivery-methods"
      resources :orders,  only: [:index, :edit, :destroy] do
        get 'confirm_invoice', 'confirm_delivery', :on => :member
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
    
    match "store/success",              to: "stores#create_success"
    match "contact",                    to: "stores#contact",       as: "store_contact"
    match "product/:handle",            to: "products#handle",      as: 'product_handle'
    match "product_search/:name",       to: "products#search",      as: 'product_search'
    match "notices/:handle",            to: "notices#show",         as: "notices"
    match "pages/:page",                to: "pages#show",           as: "pages"
    match "categories/*categories",     to: "categories#index",     as: "categories"
    match "coupon",                     to: "coupons#add_coupon",   as: "add_coupon"
    match "checkout",           to: "checkouts#new",      as: "checkout"
    match "checkout/confirm",   to: "checkouts#confirm",  via: "get",   as: "confirm_checkout"
    match "checkout/confirm",   to: "checkouts#confirm",  via: "put",   as: "confirm_checkout"
    match "checkout/charge",    to: "checkouts#charge",   as: "charge_checkout"
    match "checkout/complete",  to: "checkouts#complete", as: "complete_checkout"
    match "return_mp/:invoice_id",  to: "checkouts#return_mp", as: 'return_mp'
    match "return_pd/:invoice_id",  to: "checkouts#return_pd", as: 'return_pd'
    match "return_pg/:invoice_id",  to: "checkouts#return_pg", as: 'return_pg'
    match "sync_pd/:invoice_id",    to: "checkouts#sync_pd",   as: 'sync_pd'
    match "sync_pg/:store_id",      to: "checkouts#sync_pg",   as: 'sync_pg'
    match "sync_mp/:store_id",      to: "checkouts#sync_mp",   as: 'sync_mp'
end
