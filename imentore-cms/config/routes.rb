Imentore::Core::Engine.routes.draw do
  namespace :admin do
    # resources :asset_folders do
    #   resources :assets
    # end
    resources :pages
    resources :notices
    resources :themes do
      resources :asset_folders, except:[:show] do
        get "new/:parent_id", to: "asset_folders#new",   via: "get", as: "new_folder", :on => :collection
        resources :assets
      end
      resources :templates do
        get 'layouts', :on => :collection, to: 'templates#layouts', as: 'layouts'
        get 'view_default', 'copy_default', :on => :member
      end
    end
  end
end