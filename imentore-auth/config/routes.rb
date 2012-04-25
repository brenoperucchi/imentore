Imentore::Core::Engine.routes.draw do
  devise_for :users,
    class_name: 'Imentore::User',
    path_names: {sign_in: 'login', sign_out: 'logout'}

  devise_scope :user do
    get '/admin/login',   to: 'admin/sessions#new',    as: 'new_admin_session'
    post '/admin/login',  to: 'admin/sessions#create', as: 'admin_session'
    delete '/admin/logout',  to: 'admin/sessions#destroy', as: 'destroy_admin_session'
  end

  match 'admin',          to: "admin/sessions#new", via: "get"
end