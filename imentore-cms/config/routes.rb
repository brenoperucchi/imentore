Imentore::Core::Engine.routes.draw do
  namespace :admin do
    resources :themes do
      resources :templates, only: [:new, :create]
    end
  end
end