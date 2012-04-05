Imentore::Core::Engine.routes.draw do
  namespace :admin do
    resources :themes do
      resources :assets
      resources :templates, only: [:new, :create]
    end
  end
end