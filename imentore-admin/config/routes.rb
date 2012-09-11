AdminImentore::Admin::Engine.routes.draw do
    namespace :admin_imentore do
      root to: "dashboard#index", as: 'dashboard'
      resources :send_emails do
        get 'install_stores', 'update_stores', :on => :member
      end
      resources :themes do
        get 'install_stores', :on => :member
        get 'update_stores', :on => :member

        resources :assets
        resources :templates do
          get 'update_stores', :on => :member
        end
      end
    end

    # namespace :admin_imentore, only:[:index] do
      # resources "address"

      # match 'key_session',      to: 'dashboard#key_session',        as: 'dashboard_session'
    # end  


  # devise_for :dealers,
  #   class_name: 'Imentore::Dealer',
  #   path: 'deal',
  #   path_names: {sign_in: 'login', sign_out: 'logout'},
  #   controllers: {:sessions => "imentore/deal_admin/sessions"}

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



  # # devise_scope :deal do
  # #   get '/deal/login',   to: 'deal_admin/sessions#new',    as: 'new_deal_admin_session'
  # #   post '/deal/login',  to: 'deal_admin/sessions#create', as: 'deal_admin_session'
  # #   delete '/deal/logout',  to: 'deal_admin/sessions#destroy', as: 'destroy_deal_admin_session'
  # # end

  # namespace :deal_admin do
  #   resources :dashboard, only:[:index]
  # end

  # namespace :deal do
  #   resources :projects, only: [:new, :create, :show] do
  #     resources :proposes, only: [:new, :create]
  #   end
  #   resources :talents, only: [:new, :create]
  # end
  # namespace :deal do
  #   resource :dealer do
  #     resources :projects, only: [:new, :create]
  #     resources :talents, only: [:new, :create]
  #   end
  # end


  # match "deal",           to: "deal/dealers#index",      via: "get"
end