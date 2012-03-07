Rails.application.routes.draw do
  scope module: 'imentore' do
    namespace :admin do
      resources :themes do
        resources :templates, only: [:new, :create]
      end
    end
  end
end