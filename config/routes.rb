Rails.application.routes.draw do
  namespace :users do
    get '/',                 as: 'root',           to: 'home#index'
    get '/home',             as: 'home',           to: 'home#index'
  end
  get '/landing', to: 'landing#index', as: :landing
  root to: "landing#index"
end
