Rails.application.routes.draw do
  scope module: 'imentore' do

    match '/store/success' => "stores#create_success"
    resources :stores, only: [:new, :create]


  end
end