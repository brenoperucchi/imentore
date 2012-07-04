Imentore::Core::Engine.routes.draw do
  resource :site, only: [:show], controller: :site
end