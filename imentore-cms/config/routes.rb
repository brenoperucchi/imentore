Rails.application.routes.draw do
  scope module: 'imentore' do
    namespace :admin do
      resources :themes
    end
  end
end