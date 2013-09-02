Buffalohostage::Application.routes.draw do
  root to: "static_pages#home"
  resources :users do
    resources :songs
  end
  resources :sessions, only: [:new, :create, :destroy]
  get '/contact', to: 'static_pages#contact'
  get '/bands',   to: 'users#index'
  get '/signup',  to: 'users#new'
  get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'
end
