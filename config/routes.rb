Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root "static_pages#home"
  get  "/bookmark", to: "static_pages#bookmark"
  get  "/history", to: "static_pages#history"
  get  "/notice", to: "static_pages#notice"
  get  "/agreement", to: "static_pages#agreement"
  get  "/policy", to: "static_pages#policy"
  get  "/help", to: "static_pages#help"
  get  "/contact", to: "static_pages#contact"
  get  "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :events
  get  "/my_events", to: "events#my_events"
end
