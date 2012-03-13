Imentore::Core::Engine.routes.draw do
  namespace :admin do
    root to: "dashboard#index", as: 'dashboard'
  end
end