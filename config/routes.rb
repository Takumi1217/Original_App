Rails.application.routes.draw do
  get 'sessions/new'
  root "static_pages#home"
  get  "/search", to: "static_pages#search"
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
end
