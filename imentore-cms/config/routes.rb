Imentore::Core::Engine.routes.draw do
  namespace :admin do
    resources :pages
    resources :notices
    resources :themes do
      resources :assets
      resources :templates do
        get 'view_default', 'copy_default', :on => :member
      end
    end
  end
end