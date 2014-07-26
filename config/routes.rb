Rails.application.routes.draw do

  get 'users/new'
  resources :users
  root 'static_pages#index'
  match '/register', to: 'users#new', via: 'get'
end
