Buffalohostage::Application.routes.draw do
  root to: "static_pages#home"
  resources :users do # change 
    resources :songs
  end
  resources :sessions, only: [:new, :create, :destroy]
  #resources :songs, only: [:index]
  get '/bands',   to: 'users#index'
  get '/signup',  to: 'users#new'
  get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'
  #get "songs/show"
  match "songs/upload", :as => "upload", via: [:get, :post]
 # match "songs/delete", :as => "delete"
end
