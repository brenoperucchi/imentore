Rails.application.routes.draw do
  scope module: 'imentore' do

    namespace :admin do
      match '' => "dashboard#index", as: 'dashboard'
    end

  end
end