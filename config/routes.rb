Rails.application.routes.draw do
  get 'users/new'
  root "hello#index"
end
