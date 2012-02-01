Rails.application.routes.draw do
  devise_for :users, class_name: 'Imentore::User'
end
