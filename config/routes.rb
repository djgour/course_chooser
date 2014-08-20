Rails.application.routes.draw do

  resources :courses

  resources :courseplans do
    resources :plan_entries, only: [:new, :create, :destroy, :update]
  end

  get 'users/new'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  root 'static_pages#index'
  match '/register', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/change_active_courseplan', to: 'users#change_active_courseplan', via: 'patch'

end
