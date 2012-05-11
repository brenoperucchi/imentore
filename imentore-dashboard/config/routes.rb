Imentore::Core::Engine.routes.draw do

  namespace :admin do

    root to: "dashboard#index", as: 'dashboard'
  end
  namespace :client do
    resources "address"
    root to: "dashboard#index", as: 'dashboard'
    match 'key_session',      to: 'dashboard#key_session',        as: 'dashboard_session'
  end
end