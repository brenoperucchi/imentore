Imentore::Core::Engine.routes.draw do
  namespace :admin do

    resources :pages
    resources :notices
    resources :themes do
      resources :assets
      resources :templates
    end
  end
end