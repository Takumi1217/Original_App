Rails.application.routes.draw do
  root "static_pages#home"
  get 'static_pages/search'
  get 'static_pages/bookmark'
  get 'static_pages/notice'
  get 'static_pages/history'
  get 'static_pages/agreement'
  get 'static_pages/policy'
  get 'static_pages/help'
  get 'static_pages/contact'
  get 'users/new'
end
