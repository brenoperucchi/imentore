Imentore::Core::Engine.routes.draw do
  resource :site, only: [:show], controller: :site
  match "site/pages/:page", to: "site#index",   via: "get", as: "page_site"
end