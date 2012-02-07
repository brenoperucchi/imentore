Rails.application.routes.draw do

  devise_for :users,
    class_name: 'Imentore::User',
    path_names: {sign_in: 'login', sign_out: 'logout'}

  devise_scope :user do
    get '/admin/login',   to: 'imentore/admin/sessions#new',    as: 'new_admin_session'
    post '/admin/login',  to: 'imentore/admin/sessions#create', as: 'admin_session'
  end
end