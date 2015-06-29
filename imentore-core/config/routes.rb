Imentore::Core::Engine.routes.draw do
  resource :site, only: [:show], controller: :site
  get "site/pages/:page", to: "site#index",   via: "get", as: "page_site"
end