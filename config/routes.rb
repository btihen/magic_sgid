Rails.application.routes.draw do
  namespace :users do
    get '/',                 as: 'root',           to: 'home#index'
    get '/home',             as: 'home',           to: 'home#index'
    get '/sessions/:token',  as: 'session_create', to: 'sessions#create'
    resources :sessions,    only: [:destroy]
  end
  get '/landing', to: 'landing#index', as: :landing
  root to: "landing#index"
end
