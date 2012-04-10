Imentore::Core::Engine.routes.draw do
  namespace :admin do
    resources :themes do
      resources :assets
      resources :templates
    end
  end
end